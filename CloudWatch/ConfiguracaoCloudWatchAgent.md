# Como configurar o Agent do CloudWacth

Este agente serve para coletar métricas dos ambientes (Saindo das defaults), seja em seu emabiente Cloud AWS ou On-premisse.

1.  O primeiro passo é instalar o agente por linha de comando:

   

```
Ubuntu / Debian
sudo yum install amazon-cloudwatch-agent -y
sudo dpkg -i amazon-cloudwatch-agent.deb
```

```
Amazon Linux
sudo yum install amazon-cloudwatch-agent -y
```

```
RHEL, Rocky Linux e AlmaLinux
wget https://amazoncloudwatch-agent.s3.amazonaws.com/redhat/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
```


2.  Após instalar o agente, você precisa confiurar o mesmo.
   

```
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

Acesse este caminho, e responda as perguntas.

3.  Iniciar o serviço.

```
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
-s
```

4. Validar o funcionamento.

```
sudo tail -n 100 /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
```