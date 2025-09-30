<%!
  from servos import xc330,xm430, xm540, dualxc430, dualxc430half

  import copy
  xc330_custom = copy.copy(xc330)
  xc330_custom.type = "xc330_custom"
  xc330_custom.bracket_clearance = 0.025
  xc330_custom.lower_joint_limit = -135
  xc330_custom.upper_joint_limit =  135
%>

<%namespace name="dynamixel" file="dynamixel.xml.mako"/>
<%namespace name="meshes" file="meshes.xml.mako"/>

<mujoco>

  ${meshes.get_servo_meshes(xc330)}
  ${meshes.get_servo_meshes(xm430)}
  ${meshes.get_servo_meshes(xm540)}
  ${meshes.get_servo_meshes(dualxc430half)}
  ${meshes.get_servo_meshes(xc330_custom)}

  <worldbody>
    <light diffuse=".5 .5 .5" pos="0 0 10" dir="0 0 -1"/>

    <body name="palm" pos="0 0 0">
      <geom name="palm" pos="0.0 0 0.0" type="box" size="0.044 .016 .0150" rgba=".25 .25 1 1"/>

      <body name="finger" pos="-.056 0 0" euler="0 90 90">
    
      <!-- a regular servo in standard mount-->
      ${dynamixel.servo_start(xm540, name="servo1",next_body_name="link1",joint_name="joint1")}

        <!-- a "flipped" servo, also turned 90 degrees-->
        ${dynamixel.servo_start(xm540, name="servo2",next_body_name="link2",joint_name="joint2", mount="flipped", euler="0 90 0")}

          <!-- a regular servo, but mounted sideways and with no bracket-->
          ${dynamixel.servo_start(xm430, "servo3", "link3", "joint3", pos="0 .01425 -0.015", euler="90 0 0", bracket="minimal")}

            <!-- a dual servo -->
            ${dynamixel.dual_servo_start(dualxc430half, "servo4", "joint4", "joint5", "link5")}

              <!-- a custom servo, "flipped"-->
              ${dynamixel.servo_start(xc330_custom, "servo6", "link6", "joint6", mount="flipped")}

              ${dynamixel.servo_end()}

            ${dynamixel.dual_servo_end()}

          ${dynamixel.servo_end()}

        ${dynamixel.servo_end()}

      ${dynamixel.servo_end()}

      </body>
    </body>

  </worldbody>
</mujoco>