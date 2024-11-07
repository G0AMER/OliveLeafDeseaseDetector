import torch
from torch.utils.mobile_optimizer import optimize_for_mobile

model_dict = torch.load('C:\\Users\\gamer\\Desktop\\wetransfer_stage_2023-07-24_1626 (1)\\stage\\stage_app\\assets\\models\\best.pt', map_location="cpu")
model = model_dict["model"]
model.eval()  # Corrected this line by adding ()

example = torch.rand(1, 3, 224, 224).float()
with torch.no_grad():
    output = model(example)
traced_script_module = torch.jit.trace(model, example)
optimized_traced_model = optimize_for_mobile(traced_script_module)
optimized_traced_model._save_for_lite_interpreter("C:\\Users\\gamer\\Desktop\\wetransfer_stage_2023-07-24_1626 (1)\\stage\\stage_app\\assets\\models\\model.pt")
