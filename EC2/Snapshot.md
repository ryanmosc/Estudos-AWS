# SNAPSHOT

São um registro de um estado atual do sistema.

**IMPORTANTE:**
- Snapshot é um backup incremental (Não é valido como backup de fato)
- Snapshots são serviços caros dentro da AWS (Muito caro)
- Todo volume EBS é baseado em uma snapshot
- Podemos fazer uma snapshot de um volume ou instancia (Se for por instancia, podemos fazer a snapshot de algum volume especifico que tem dentro da instancia)
  
**Uma snapshot é feita da seguinte forma:**
Imagine que você tem um volume EBS de 15G, a primeira snapshot é feita de forma integral (A grande massa de dados é copiada) as proximas são feitas como base nas modificações.
Pense que após a primeira snapshot, foi alterado 4G de dados. A proxima snapshot só será feita destes 4G. Na terceira snapshot foi alterado 3G. Sera somente feito a Snapshot dos 3G.
O serviço de snapshot faz uma associação entre os volumes, igual o docker com seu cache.