using Godot;
using System;
using TorchSharp;
using static TorchSharp.torch.nn;

public class NN1 : Node
{
	private Random random;
	
	public override void _Ready()
	{
		random = new Random();
	}
	
	public int get_next_state(Godot.Image frame){
		int randomNumber = random.Next(-1,1);
		return randomNumber;
	}

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
