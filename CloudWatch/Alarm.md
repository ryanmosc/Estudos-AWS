# Alarmes CloudWatch

Os alarmes são recursos que nos alertam quando algo ou determinado parametro está fora do esperado. Como exemplo, um uso fora do normal de CPU.

## Como criar um alarme:

```
CloudWatch
   |
   |
Alarms
   |
   |
Selecione o tipo do alarme e o tipo de dado
   | 
   |
Selecione a metrica que será usada como base
   | 
   |
Configure as condições como for melhor para seu uso
   |
   |
Selecione uma ação (SNS, Lambda, ASG etc...)
   |
   |
Termine a personalização
```