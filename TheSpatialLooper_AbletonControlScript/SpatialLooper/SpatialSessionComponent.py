from _Framework.SessionComponent import SessionComponent
from .SpatialSceneComponent import SpatialSceneComponent

# mediates the custom clip slots
class SpatialSessionComponent(SessionComponent):
    scene_component_type = SpatialSceneComponent

    def __init__(self, *a, **k):
        (super(SpatialSessionComponent, self).__init__)(*a, **k)