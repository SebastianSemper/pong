#include "reinforced.h"
#include <memory>

using namespace godot;

void GDReinforced::_register_methods() {
  register_method("_process", &GDReinforced::_process);
  register_method("_process_image", &GDReinforced::_process_image);
}

GDReinforced::GDReinforced() {}

GDReinforced::~GDReinforced() {
  // add your cleanup here
}

void GDReinforced::_init() {
  input_tensor = new tensorflow::Tensor(
      tensorflow::DataType::DT_UINT8, tensorflow::TensorShape({1, 64, 64, 1}));

  scope = new tensorflow::Scope(tensorflow::Scope::NewRootScope());
  session = new tensorflow::ClientSession(*scope);

  int_input =
      new tensorflow::ops::Placeholder(*scope, tensorflow::DataType::DT_UINT8);
  flt_input = new tensorflow::ops::Cast(*scope, *int_input,
                                        tensorflow::DataType::DT_FLOAT);
  sum_output = new tensorflow::ops::Sum(*scope, *flt_input, {0, 1, 2, 3});
}

void GDReinforced::_process(float delta) {}

int GDReinforced::_process_image(Image *img) {
  // https://github.com/tensorflow/tensorflow/issues/8033

  PoolByteArray rawData = img->get_data();

  memcpy(input_tensor->flat<uint8_t>().data(), rawData.read().ptr(),
         64 * 64 * sizeof(uint8_t));

  std::vector<tensorflow::Tensor> outputs;

  session->Run({{*int_input, *input_tensor}}, {*sum_output}, {}, &outputs);
  return int(outputs[0].flat<float>().data()[0]);
}