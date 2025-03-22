from _Framework.SceneComponent import SceneComponent
from .SpatialClipSlotComponent import SpatialClipSlotComponent

# mediates the custom clip slots
class SpatialSceneComponent(SceneComponent):
    clip_slot_component_type = SpatialClipSlotComponent

    def __init__(self, *a, **k):
        (super(SpatialSceneComponent, self).__init__)(*a, **k)
