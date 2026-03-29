#!/usr/bin/env python3
import sys
import copy
import os
import xml.etree.ElementTree as ET
from mjcf_urdf_simple_converter import convert


def process_urdf(urdf_file, package_name, root_link_name):
    tree = ET.parse(urdf_file)
    root = tree.getroot()

    robot_name = os.path.splitext(os.path.basename(urdf_file))[0]
    if root.tag == "robot":
        root.set("name", robot_name)
        print(f"Robot name in urdf set to '{robot_name}'")

    print("Ensuring every link has both visual and collision geometry")
    for link in root.findall("link"):
        visuals = link.findall("visual")
        collisions = link.findall("collision")

        # Case 1: Link has <visual> but no <collision>
        if visuals and not collisions:
            for vis in visuals:
                new_collision = copy.deepcopy(vis)
                new_collision.tag = "collision"
                link.append(new_collision)

        # Case 2: Link has neither
        if not visuals and not collisions:
            sphere_xml = ET.Element("geometry")
            sphere = ET.SubElement(sphere_xml, "sphere")
            sphere.set("radius", "0.002")

            vis = ET.Element("visual")
            vis.append(copy.deepcopy(sphere_xml))
            link.append(vis)

            col = ET.Element("collision")
            col.append(copy.deepcopy(sphere_xml))
            link.append(col)

    print(f"Renaming 'world' link to {root_link_name}")
    world_link = None
    for link in root.findall("link"):
        if link.get("name") == "world":
            world_link = link
            break

    if world_link is None:
        print(f"[INFO] No link named 'world' found; skipping rename")
    else:
        # Safety: don't clobber an existing link name
        if any(l.get("name") == root_link_name for l in root.findall("link")):
            raise ValueError(f"Cannot rename link to '{root_link_name}': link '{root_link_name}' already exists")

        world_link.set("name", root_link_name)
        print(f"Renamed link 'world' → '{root_link_name}'")

        # Update any joint parent/child references
        updated = 0
        for joint in root.findall("joint"):
            parent = joint.find("parent")
            child = joint.find("child")

            if parent is not None and parent.get("link") == "world":
                parent.set("link", root_link_name)
                updated += 1
            
            jname = joint.get("name")
            if jname and "world" in jname:
                joint.set("name", jname.replace("world", root_link_name))

        print(f"Updated {updated} joint parent link reference(s) from 'world' → '{root_link_name}'")

    print("Ensuring all joint velocity limits are written as floats")
    for joint in root.findall("joint"):
        limit = joint.find("limit")
        if limit is not None and "velocity" in limit.attrib:
            v = limit.attrib["velocity"]
            try:
                # Convert to float and back, forcing ".0" if integer
                v_float = float(v)
                if v_float.is_integer():
                    v_float = v_float + 0.1
                limit.attrib["velocity"] = str(v_float)
            except ValueError:
                print(f"[WARN] Joint '{joint.attrib['name']}': velocity '{v}' is not a number, skipping")
    

    indent(root)
    tree.write(urdf_file, encoding="utf-8", xml_declaration=True)
    print(f"URDF post-processed and saved: {urdf_file}")
    print(f"'{urdf_file}' should now go in '{package_name}/urdf', and the generated mesh files found in './meshes' should go in '{package_name}/urdf/meshes'")


def indent(elem, level=0):
    """Pretty-print XML (recursive)."""
    i = "\n" + level * "  "
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "  "
        for e in elem:
            indent(e, level + 1)
        if not e.tail or not e.tail.strip():
            e.tail = i
    if level and (not elem.tail or not elem.tail.strip()):
        elem.tail = i


if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: python3 xml2urdf.py input.xml output.urdf package_name root_link_name")
        sys.exit(1)

    xml_file = sys.argv[1]
    urdf_file = sys.argv[2]
    package_name = sys.argv[3]
    root_link_name = sys.argv[4]

    # Step 1: Convert MJCF XML → URDF
    print(f"Converting {xml_file} → {urdf_file}")
    prefix = f"package://{package_name}/urdf/"
    convert(xml_file, urdf_file, asset_file_prefix = prefix)

    # Step 2: Add collisions + fix mesh paths
    process_urdf(urdf_file, package_name, root_link_name)
