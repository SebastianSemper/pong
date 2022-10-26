#include "reinforced.h"

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
  // initialize any variables here
  time_passed = 0.0;
}

void GDReinforced::_process(float delta) {}

int GDReinforced::_process_image(Image *img) {
  // https://github.com/tensorflow/tensorflow/issues/8033

  PoolByteArray rawData = img->get_data();
  const uint8_t *imagePointer = rawData.read().ptr();

  tensorflow::Tensor tensor = tensorflow::Tensor(
      tensorflow::DataType::DT_UINT8, tensorflow::TensorShape({64, 64}));

  uint8_t *tensorPointer = tensor.flat<uint8_t>().data();
  memcpy(tensorPointer, imagePointer, 64 * 64 * sizeof(uint8_t));
  return 0;
}