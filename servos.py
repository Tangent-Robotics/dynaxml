from dataclasses import dataclass
import copy

@dataclass
class Servo:
    type: str
    x_dim: float
    y_dim: float
    z_dim: float
    face_to_axis: float
    bracket_clearance: float
    lower_joint_limit: float
    upper_joint_limit: float
    joint_offset_y: float = 0
    joint_offset_z: float = 0

xc330 = Servo(
    type = "xc330",
    x_dim = 0.023,
    y_dim = 0.034,
    z_dim = 0.020,
    face_to_axis = 0.0095,
    bracket_clearance = 0.017,
    lower_joint_limit = -120,
    upper_joint_limit = 120,
)

xm430 = Servo(
    type = "xm430",
    x_dim = 0.0340,
    y_dim = 0.0465,
    z_dim = 0.0285,
    face_to_axis = 0.01125,
    bracket_clearance = 0.028,
    lower_joint_limit = -120,
    upper_joint_limit = 120,
)

xm540 = Servo (
    type = "xm540",
    x_dim = 0.0440,
    y_dim = 0.0585,
    z_dim = 0.0335,
    face_to_axis = 0.01375,
    bracket_clearance = 0.032,
    lower_joint_limit = -120,
    upper_joint_limit = 120,
)

dualxc430 = Servo (  
    type = "dualxc430",
    x_dim = 0.0360,
    y_dim = 0.0465,
    z_dim = 0.0360,
    face_to_axis = 0.01125,
    bracket_clearance = 0.028,
    lower_joint_limit = -120,
    upper_joint_limit = 120,
)

dualxc430half = copy.copy(dualxc430)
dualxc430half.type = "dualxc430half"
dualxc430half.y_dim *= 0.5
