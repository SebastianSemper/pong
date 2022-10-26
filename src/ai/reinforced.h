#ifndef GDREINFORCED_H
#define GDREINFORCED_H

#include <string>

#include <Array.hpp>
#include <Godot.hpp>
#include <Image.hpp>
#include <Node.hpp>
#include <PoolArrays.hpp>
#include <Variant.hpp>
#include <memory>

#include <tensorflow/cc/client/client_session.h>
#include <tensorflow/cc/ops/standard_ops.h>
#include <tensorflow/core/framework/tensor.h>

namespace godot {

class GDReinforced : public Node {
  GODOT_CLASS(GDReinforced, Node)

private:
  float time_passed;

public:
  static void _register_methods();

  GDReinforced();
  ~GDReinforced();

  void _init(); // our initializer called by Godot

  void _process(float delta);

  int _process_image(Image *);
};

} // namespace godot

#endif