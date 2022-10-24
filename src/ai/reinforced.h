#ifndef GDREINFORCED_H
#define GDREINFORCED_H

#include <Godot.hpp>
#include <Sprite.hpp>
#include <tensorflow/cc/client/client_session.h>
#include <tensorflow/cc/ops/standard_ops.h>
#include <tensorflow/core/framework/tensor.h>

namespace godot {

class GDReinforced : public Sprite {
  GODOT_CLASS(GDReinforced, Sprite)

private:
  float time_passed;

public:
  static void _register_methods();

  GDReinforced();
  ~GDReinforced();

  void _init(); // our initializer called by Godot

  void _process(float delta);
};

} // namespace godot

#endif