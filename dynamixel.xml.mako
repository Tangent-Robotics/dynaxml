<%!
    use_primitives = True
%>

<%def name="servo_start(servo, 
                        name, next_body_name,joint_name,
                        pos = '0 0 0', euler = '0 0 0',
                        mount = 'standard', bracket = 'normal')">
<%
    x_dim = servo.x_dim
    y_dim = servo.y_dim
    z_dim = servo.z_dim
    face_to_axis = servo.face_to_axis
    bracket_clearance = servo.bracket_clearance
    joint_offset_y = servo.joint_offset_y
    joint_offset_z = servo.joint_offset_z
    mesh = servo.type
    lower_joint_limit = servo.lower_joint_limit
    upper_joint_limit = servo.upper_joint_limit
    axis_size = x_dim + 0.006
    bracket_width = 0.002
    fourbar_bearing_radius = 0.006
    axis_to_next_body = bracket_clearance
    front_padding = servo.front_padding
    top_padding = servo.top_padding
%>
% if mount == "standard":
<body name="${name}_body" pos="${pos}" euler="${euler}">
% if use_primitives:
<geom name="${name}_body" type="box" size="${x_dim/2.0} ${y_dim/2.0} ${z_dim/2.0}" pos="0 ${y_dim/2.0} 0" rgba="0.5 0.5 0.75 1"/>
<geom name="${name}_axis" type="cylinder" size=".005 ${axis_size/2.0}" pos="0 ${y_dim-face_to_axis} 0" euler="0 90 0" contype="0" conaffinity="0"/>
  % if front_padding > 0:
    <geom name="${name}_body_front_padding" type="box" size="${x_dim/2.0-0.002} ${y_dim/2.0-0.002} ${front_padding}" pos="0 ${y_dim/2.0} ${z_dim/2.0+front_padding/2.0}" rgba="0.5 0.75 0.5 1"/>
  %endif
  % if top_padding > 0:
    <geom name="${name}_body_top_padding" type="box" size="${x_dim/2.0-0.002} ${top_padding} ${z_dim/2.0-0.002}" pos="0 ${y_dim+top_padding/2.0} 0" rgba="0.5 0.75 0.5 1"/>
  %endif
% else:
<geom name="${name}_body" type="mesh" mesh="${mesh}_body" pos="0 ${y_dim/2.0} 0" rgba="0.5 0.5 0.75 1"/>
% endif
<body name="${name}_bracket" pos="0 ${y_dim-face_to_axis+joint_offset_y} ${joint_offset_z}" euler="0 0 0" >
  <inertial pos="0 0 0" mass="0.05" diaginertia="1e-5 1e-5 1e-5"/>
  <joint type="hinge" name="${joint_name}" axis="1 0 0" limited="true" range="${lower_joint_limit} ${upper_joint_limit}"/>  
% if use_primitives:
  % if bracket == "normal":
    <geom name="${name}_bracket_1" type="box" size="${axis_size/2.0} ${bracket_width/2.0} ${z_dim/2.0}" pos="0 ${axis_to_next_body-bracket_width/2.0} 0" rgba=".25 .25 .25 1"/>
    <geom name="${name}_bracket_2" type="box" size="${bracket_width/2.0} ${bracket_clearance/2.0} ${z_dim/2.0}" pos="${axis_size/2.0-bracket_width/2.0} ${axis_to_next_body/2.0} 0" rgba=".25 .25 .25 1"/>
    <geom name="${name}_bracket_3" type="box" size="${bracket_width/2.0} ${bracket_clearance/2.0} ${z_dim/2.0}" pos="${-(axis_size/2.0-bracket_width/2.0)} ${axis_to_next_body/2.0} 0" rgba=".25 .25 .25 1"/>
  % elif bracket == "minimal":
    <geom name="${name}_bracket_2" type="box" size="${bracket_width/2.0} ${face_to_axis/2.0} ${face_to_axis/2.0}" pos="${axis_size/2.0-bracket_width/2.0} 0 0" rgba=".25 .25 .25 1"/>
    <geom name="${name}_bracket_3" type="box" size="${bracket_width/2.0} ${face_to_axis/2.0} ${face_to_axis/2.0}" pos="${-(axis_size/2.0-bracket_width/2.0)} 0 0" rgba=".25 .25 .25 1"/>
  % elif bracket == "fourbar":
    <geom name="${name}_bracket_1" type="cylinder" size="${fourbar_bearing_radius} ${bracket_width}" pos="${axis_size/2.0-bracket_width/2.0} 0 0" euler="0 90 0" rgba=".25 .25 .25 1"/>
    <geom name="${name}_bracket_2" type="cylinder" size="${fourbar_bearing_radius} ${bracket_width}" pos="${-(axis_size/2.0-bracket_width/2.0)} 0 0" euler="0 90 0" rgba=".25 .25 .25 1"/>
  % else:
    <!-- Unsupported bracket type-->
  % endif
% else:
  % if bracket == "normal":
    <geom name="${name}_bracket" type="mesh" mesh="${mesh}_bracket" pos="0 ${axis_to_next_body-.001} 0"/>
    <geom name="${name}_bracket_side1" type="mesh" mesh="${mesh}_bracket_side" pos="${ axis_size/2.0 - 0.001} ${axis_to_next_body/2.0} 0"/>
    <geom name="${name}_bracket_side2" type="mesh" mesh="${mesh}_bracket_side" pos="${-axis_size/2.0 + 0.001} ${axis_to_next_body/2.0} 0"/>
  % elif bracket == "minimal":
    <geom name="${name}_bracket_side1" type="mesh" mesh="${mesh}_bracket_side_minimal" pos="${ axis_size/2.0 - 0.001} 0 0"/>
    <geom name="${name}_bracket_side2" type="mesh" mesh="${mesh}_bracket_side_minimal" pos="${-axis_size/2.0 + 0.001} 0 0"/>
  % elif bracket == "fourbar":
    <geom name="${name}_bracket_1" type="mesh" mesh="${mesh}_bracket_side_fourbar" pos="${axis_size/2.0-bracket_width/2.0} 0 0" />
    <geom name="${name}_bracket_2" type="mesh" mesh="${mesh}_bracket_side_fourbar" pos="${-(axis_size/2.0-bracket_width/2.0)} 0 0" />
  % else:
    <!-- Unsupported bracket type-->
  %endif
%endif
<body name="${next_body_name}" pos="0 ${axis_to_next_body} 0">
% elif mount == "flipped":
<body name="${name}_bracket" pos="${pos}" euler="${euler}">
% if use_primitives:
  % if bracket == "normal":
    <geom name="${name}_prev_bracket_1" type="box" size="${axis_size/2.0} ${bracket_width/2.0} ${z_dim/2.0}" pos="0 ${-bracket_width/2.0} 0" rgba=".25 .25 .25 1"/>
    <geom name="${name}_prev_bracket_2" type="box" size="${bracket_width/2.0} ${bracket_clearance/2.0} ${z_dim/2.0}" pos="${axis_size/2.0-bracket_width/2.0} ${-bracket_clearance/2.0} 0" rgba=".25 .25 .25 1"/>
    <geom name="${name}_prev_bracket_3" type="box" size="${bracket_width/2.0} ${bracket_clearance/2.0} ${z_dim/2.0}" pos="${-(axis_size/2.0-bracket_width/2.0)} ${-bracket_clearance/2.0} 0" rgba=".25 .25 .25 1"/>
  % elif bracket == "minimal":
    <geom name="${name}_prev_bracket_2" type="box" size="${bracket_width/2.0} ${face_to_axis/2.0} ${face_to_axis/2.0}" pos="${axis_size/2.0-bracket_width/2.0} 0 0" rgba=".25 .25 .25 1"/>
    <geom name="${name}_prev_bracket_3" type="box" size="${bracket_width/2.0} ${face_to_axis/2.0} ${face_to_axis/2.0}" pos="${-(axis_size/2.0-bracket_width/2.0)} 0 0" rgba=".25 .25 .25 1"/>
  % elif bracket == "fourbar":
    <geom name="${name}_prev_bracket_1" type="cylinder" size="${fourbar_bearing_radius} ${bracket_width}" pos="${axis_size/2.0-bracket_width/2.0} ${-bracket_clearance} 0" euler="0 90 0" rgba=".25 .25 .25 1"/>
    <geom name="${name}_prev_bracket_2" type="cylinder" size="${fourbar_bearing_radius} ${bracket_width}" pos="${-(axis_size/2.0-bracket_width/2.0)} ${-bracket_clearance} 0" euler="0 90 0" rgba=".25 .25 .25 1"/>
  % else:
    <!-- Unsupported bracket type-->
  %endif
% else:
  % if bracket == "normal":
    <geom name="${name}_bracket" type="mesh" mesh="${mesh}_bracket" pos="0 -.001 0"/>
    <geom name="${name}_bracket_side1" type="mesh" mesh="${mesh}_bracket_side" pos="${ axis_size/2.0 - 0.001} ${-axis_to_next_body/2.0} 0"/>
    <geom name="${name}_bracket_side2" type="mesh" mesh="${mesh}_bracket_side" pos="${-axis_size/2.0 + 0.001} ${-axis_to_next_body/2.0} 0"/>
  % elif bracket == "minimal":
    <geom name="${name}_bracket_side1" type="mesh" mesh="${mesh}_bracket_side_minimal" pos="${ axis_size/2.0 - 0.001} ${-axis_to_next_body} 0"/>
    <geom name="${name}_bracket_side2" type="mesh" mesh="${mesh}_bracket_side_minimal" pos="${-axis_size/2.0 + 0.001} ${-axis_to_next_body} 0"/>
  % else:
    <!-- Unsupported bracket type-->
  % endif
% endif
<body name="${name}_body" pos="0 ${-axis_to_next_body} 0" euler="0 0 0" >
  <joint type="hinge" name="${joint_name}" axis="-1 0 0" limited="true" range="${lower_joint_limit} ${upper_joint_limit}"/>  
% if use_primitives:
  <geom name="${name}_axis1" type="cylinder" size=".005 ${axis_size/2.0}" pos="0 ${-joint_offset_y} ${joint_offset_z}" euler="0 90 0" contype="0" conaffinity="0"/>
  <geom name="${name}" type="box" size="${x_dim/2.0} ${y_dim/2.0} ${z_dim/2.0}" pos="0 ${-(y_dim/2.0-face_to_axis+joint_offset_y)} ${joint_offset_z}" rgba="0.5 0.5 0.75 1"/>
%else:
  <geom name="${name}_body" type="mesh" mesh="${mesh}_body" pos="0 ${-(y_dim/2.0-face_to_axis+joint_offset_y)} ${joint_offset_z}" rgba="0.5 0.5 0.75 1"/>
%endif
  <body name="${next_body_name}" pos="0 ${-(y_dim-face_to_axis+joint_offset_y)} ${joint_offset_z}">
% else:
<!-- Unsupported mount ${mount} requested-->  
% endif
</%def>

<%def name="servo_end()">
</body>
</body>
</body>
</%def>

<%def name="dual_servo_hetero_start(servo1, servo2, 
                                    name,joint1_name,joint2_name,next_body_name,
                                    pos='0 0 0', euler='0 0 0', servo_to_servo='standard',
                                    prox_bracket='normal', dist_bracket='minimal')">
<%
    first_name = name + "first"
    bridge_name = name + "bridge"
    second_name = name + "second"
%>
${servo_start(servo1,
              first_name, bridge_name, joint1_name, 
              pos, euler,                       
              "flipped", prox_bracket)}
% if servo_to_servo == "standard":
${servo_start(servo2,
              second_name, next_body_name, joint2_name, 
              "0 0 0", "180 90 0",                      
              "standard", dist_bracket)}
% elif servo_to_servo == "flipped":
${servo_start(servo2,
              second_name, next_body_name, joint2_name, 
              "0 0 0", "180 -90 0",                      
              "standard",dist_bracket)}
% else:
<!-- Unsupported servo_to_servo ${servo_to_servo} requested-->  
% endif
</%def>


<%def name="dual_servo_start(servo, 
                             name,joint1_name,joint2_name,next_body_name,
                             pos='0 0 0', euler='0 0 0', servo_to_servo='standard', 
                             prox_bracket='normal', dist_bracket='normal')">
${dual_servo_hetero_start(servo, servo, 
                          name, joint1_name, joint2_name, next_body_name,
                          pos, euler, servo_to_servo, prox_bracket, dist_bracket)}
</%def>

<%def name="dual_servo_end()">

</body>
</body>
</body>
</body>
</body>
</body>

</%def>
