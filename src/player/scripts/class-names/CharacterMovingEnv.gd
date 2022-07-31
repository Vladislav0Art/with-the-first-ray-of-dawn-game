# @descr: class contains consts related to moving

extends Node

class_name CharacterMovingEnv

const WalkSpeed : int = 70
const RunSpeed  : int = 120

const WalkAcceleration : int = 350
const RunAcceleration  : int = 500

const Friction : int = 450

const MaxStamina             : float = 100.0
const RunningMaxTime_ms      : int   = 3000
const StaminaConsumptionCoef : float = MaxStamina / (RunningMaxTime_ms / 1000)
const StaminaRecoveryTime_ms : int   = 4000
const StaminaRecoveryUnit    : float = MaxStamina / (StaminaRecoveryTime_ms / 1000)
