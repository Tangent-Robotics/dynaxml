<%def name="box_mesh(name, x, y, z)">
<%
    xh = x/2.0
    yh = y/2.0
    zh = z/2.0
%>
<asset>
  <mesh name="${name}" vertex=" ${xh}  ${yh}  ${zh}
                               -${xh}  ${yh}  ${zh}
                                ${xh} -${yh}  ${zh}
                                ${xh}  ${yh} -${zh}
                                ${xh} -${yh} -${zh}
                               -${xh}  ${yh} -${zh}
                               -${xh} -${yh}  ${zh}
                               -${xh} -${yh} -${zh}
                                "/>
</asset>
</%def>

<%def name="get_servo_meshes(servo)">
  ${box_mesh(servo.type+"_body", servo.x_dim, servo.y_dim, servo.z_dim)}
  ${box_mesh(servo.type+"_bracket", servo.x_dim+0.006, 0.002, servo.z_dim)}
  ${box_mesh(servo.type+"_bracket_side", 0.002, servo.bracket_clearance, servo.z_dim)}
  ${box_mesh(servo.type+"_bracket_side_minimal", 0.002, servo.face_to_axis, servo.face_to_axis)}
  ${box_mesh(servo.type+"_bracket_side_fourbar", 0.002, 0.006, 0.006)}
</%def>

