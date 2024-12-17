# Filtre FIR-LMS sur System Generator for DSP

## Introduction

Ce rapport présente le développement d’un filtre FIR-LMS sur FPGA à l’aide de MATLAB et System Generator for DSP. La gestion du projet via un dépôt GitHub inclut une licence justifiée et des pratiques de versionnage. La modélisation dans System Generator est validée par comparaison avec MATLAB, en abordant les problèmes d’arrondi et de dépassement. Les performances matérielles sont évaluées à partir des résultats de synthèse. Des optimisations, comme le relaxed-lookahead et le retiming, améliorent l’efficacité du design. Enfin, le rapport détaille les étapes et les coûts pour porter le design vers une implémentation FPGA avec IP Integrator.

## 1. Architecture du FIR-LMS

Le filtre FIR-LMS est une architecture adaptative utilisée pour minimiser une erreur entre une sortie calculée et une référence désirée. Combinant un filtre FIR (Finite Impulse Response) et un algorithme LMS (Least Mean Squares), il permet d’ajuster dynamiquement les coefficients du filtre en fonction de l’erreur, rendant le système efficace pour des applications telles que l’égalisation de canaux, la suppression de bruit, et l’estimation de signaux. Avec System Generator for DSP, le FIR-LMS peut être modélisé graphiquement en exploitant des blocs optimisés pour le traitement numérique des signaux, simplifiant ainsi le développement pour les implémentations FPGA. Cette approche permet une conception rapide, une simulation intégrée avec MATLAB/Simulink, et une optimisation des ressources matérielles tout en garantissant des performances élevées. 

###   1.1 Filtre FIR

![image](https://github.com/user-attachments/assets/4be32fe0-6e5b-4a60-8f13-c9f458f535e1)

Cette figure montre l’architecture d’un filtre FIR modélisé dans System Generator for DSP. Le signal d’entrée xk passe à travers des registres de décalage pour générer des versions décalées (xk-n) multipliées par les coefficients adaptatifs (wn,k). Les produits sont ensuite sommés dans un accumulateur pour produire la sortie yk. Finalement, nous obtenons la sortie du FIR qui est out_sysgen. Cette structure modulaire optimise les ressources FPGA tout en assurant un traitement efficace en pipeline. FIR-LMS

###   1.2 Filtre FIR-LMS

![image](https://github.com/user-attachments/assets/ff3f603a-fc37-4493-af6b-6cd4c25be035)

La figure représente un filtre adaptatif FIR-LMS (Finite Impulse Response - Least Mean Squares) utilisé pour minimiser une erreur entre un signal de sortie estimé et une référence. Le signal d'entrée passe par des blocs de délais pour générer des échantillons successifs, multipliés par des coefficients adaptatifs. Ces coefficients, mis à jour dynamiquement par l'algorithme LMS, sont calculés en fonction de l'erreur entre la sortie et le signal de référence. L'erreur, calculée comme la différence entre la sortie filtrée et le signal désiré, est utilisée pour ajuster les coefficients selon une règle d’apprentissage proportionnelle au produit de l’erreur et du signal d’entrée. Le schéma illustre clairement l'architecture modulaire du filtre et son processus d'adaptation.

## 2. Résultats de simulation

Cette section du rapport présente les résultats de simulation obtenus pour le filtre FIR-LMS. 

### 2.1 FIR

Tout d’abord, voici les résultats de simulation pour le FIR :

![image](https://github.com/user-attachments/assets/6cf94364-056f-478a-9515-c2a59658fa83)

Ce graphique compare les résultats de simulation du filtre FIR-LMS implémenté avec DSP System Generator (cercles bleus) avec ceux de MATLAB (étoiles rouges), utilisé comme référence. Les amplitudes des deux signaux sont presque parfaitement superposées sur l’ensemble des échantillons, ce qui démontre que l’implémentation du FIR-LMS dans Sysgen est fidèle au modèle MATLAB. Cela valide le fonctionnement correct de l'algorithme LMS dans l'environnement Sysgen. Les éventuelles différences minimes pourraient être attribuées à des limitations de précision numérique ou au format des données dans Sysgen. Ces résultats confirment la robustesse et l’exactitude de l’implémentation.

### 2.2 FIR-LMS

Tout d’abord, voici les résultats de simulation pour le FIR-LMS:

![image](https://github.com/user-attachments/assets/58e5f1c3-9fa6-446e-a54c-b0fd6db56878)

Comme nous pouvons voir dans la capture précédente, les valeurs d’entrées convergent aux mêmes valeurs que celles de références (0,5 et -0,5. De plus, il est aussi possible de voir que l’erreur au niveau du FIR-LMS est minime. Elle se rapproche en effet extrêmement de 0. C’est donc dire que le FIR-LMS est bel et bien fonctionnel.

## 3. Résultat de synthèse

Cette partie du rapport présentera les résultats de synthèse obtenus lors de l'implémentation du filtre FIR-LMS. Les résultats de synthèse du projet non optimisés et optimisés seront d’abord présentés. Ensuite, ce sera le tour des résultats des laboratoires A et B. Finalement, le tout sera comparé.

### 3.1 FIR-LMS avec System generator for DSP

Tout d’abord, voici les résultats de synthèse de ressources non optimisés :

![image](https://github.com/user-attachments/assets/f7c0d25d-67c7-445a-b59e-c9b3fa51f32f)

Le tableau présente l'utilisation des ressources matérielles pour le filtre FIR-LMS après synthèse. On observe que chaque multiplicateur (Mult0 à Mult9) utilise des DSPs, reflétant une consommation uniforme pour les opérations arithmétiques. Les additions/soustractions (AddSub0 à AddSub9) consomment principalement des LUTs. La ressource principale du design global, FIR_LMS_2, utilise 192 LUTs et 208 registres, sans aucune utilisation de BRAMs. Ces résultats montrent une répartition efficace des ressources avec une optimisation des DSPs pour les calculs intensifs et des LUTs pour les opérations logiques. Cela reflète une conception équilibrée adaptée aux contraintes de performance et de ressources matérielles. 

Maintenant, voici les résultats de synthèse de timing non optimisés :

![image](https://github.com/user-attachments/assets/ce73b07e-48bb-4363-a08b-d6e0d5eee39d)

Le tableau présente l’analyse de timing pour le filtre FIR-LMS. Les chemins critiques sont clairement identifiés avec leurs valeurs de slack (35,338 ns et 49,404 ns), montrant que toutes les contraintes temporelles sont respectées (statut "PASSED"). Le délai total est décomposé en logic delay (10,176 ns pour les chemins les plus longs 0,216 ns pour les plus courts) et routing delay (4,473 ns pour les chemins les plus longs et 0,194 ns pour les plus courts), mettant en évidence l'efficacité du routage et de la logique dans le design. Les niveaux de logique sont relativement faibles (23 au maximum, 0 au minimum), indiquant une complexité modérée dans la chaîne de traitement. Les contraintes de timing imposées par l'horloge (période de 50 ns) sont satisfaites, assurant une exécution sans violation temporelle. 

### 3.2 Comparaison avec les laboratoires A et B

La comparaison entre les laboratoires A3, B3 et le projet FIR-LMS met en évidence des différences significatives en termes d’utilisation des ressources et de performances. Le Lab A3 se distingue par une utilisation optimisée des DSPs (12 utilisés) pour les calculs intensifs, une faible occupation des Slice LUTs (482, soit 0,47 %) et des Slice Registers (351, soit 0,34 %), et une latence critique minimale de 8,354 ns grâce à une bonne gestion des chemins critiques et une logique combinatoire limitée. Cette conception est clairement orientée vers une performance optimale, avec des ressources équilibrées et des timings respectés. En revanche, le Lab B3, qui n’utilise aucun DSP, s’appuie exclusivement sur les LUTs pour les opérations arithmétiques, augmentant leur utilisation (977 LUTs, soit 0,96 %) tout en réduisant considérablement celle des registres (112, soit 0,06 %). Cette absence de DSPs et un routage intensif (70,805 % du délai total) expliquent une latence critique plus élevée (25,850 ns).

Le projet FIR-LMS, quant à lui, présente une très faible occupation des ressources FPGA, avec seulement 192 Slice LUTs et 208 Slice Registers, et n’exploite également aucun DSP ni BRAM, ce qui reflète une architecture simplifiée. Malgré cela, la latence critique atteint 35,338 ns, légèrement supérieure à celle du Lab B3, bien que le nombre de niveaux logiques soit plus faible (23 contre 50). Ces résultats suggèrent que le projet, bien que fonctionnel et utilisant peu de ressources, pourrait être amélioré en intégrant des DSPs pour réduire l’utilisation des LUTs et en optimisant les chemins critiques pour diminuer les délais de routage. En s’inspirant des approches d’A3, telles que l’exploitation des DSPs et une meilleure gestion des registres, il serait possible d’obtenir une performance similaire tout en maintenant une occupation minimale des ressources. 

## 4. Techniques d'optimisation

### Technique de relaxed look-ahead
Cette technique sert à optimiser la performance du système tout en maintenant une surveillance pour traiter les erreurs. Ainsi, le lookahead fait une estimation du délai avant un événement et la relaxation amène la flexibilité de surveiller les corrections et d’avancer dans le code de façon optimiste. 

Cette technique permet d’améliorer les performances comme elle permet d’être proactif dans le temps. Elle est flexible dans le traitement d’architectures parallèles et s’adapte facilement. Toutefois, si le lookahead est mal estimé, des erreurs fréquentes peuvent survenir et engendrer des coûts lors de la conception. L’utilisation de cette technique demeure complexe.

Dans le laboratoire C3, il était demandé d’appliquer cette technique sur les résultats du laboratoire C2. Nous devions donc ajouter les délais D1 et D2 ainsi que les sections rouges à l’architecture existante, tel qu’indiqué dans la figure suivante.

![image](https://github.com/user-attachments/assets/26746702-3a7f-40d7-bb4b-3ef44ed42cce)

Voici le schéma de l’architecture avec la technique de relaxed-lookahead, où le chemin critique est indiqué en vert :

![image](https://github.com/user-attachments/assets/a2b1ee7c-e117-4869-ad77-60d2c12438e6)

Voici le rapport des ressources avec l’application de la technique de relaxed-lookahead :

![image](https://github.com/user-attachments/assets/1fc739d1-c8fe-420f-a18d-556b55440ec7)

On peut voir que chaque multiplicateur utilise des DSPs avec une consommation uniforme pour les opérations arithmétiques. Les additions/soustractions consomment principalement des LUTs. Les délais consomment principalement des LUTs et des registres. La ressource principale du design global, FIR_LMS_3, utilise 473 LUTs et 400 registres, soit environ le double du système non optimisé (192 LUTs et 208 registres), sans aucune utilisation de BRAMs. 

Voici le rapport des timings avec l’application de la technique de relaxed-lookahead :

![image](https://github.com/user-attachments/assets/1c861f16-222c-411d-a660-0104ad1b31cd)

Le plus long chemin, donc le chemin critique prend 11,26 ns avec 38,65 ns de slack. C’est donc une optimisation, car sans cette technique le chemin critique prenait 14,65 ns. Ainsi, cette technique de relaxed-lookahed permet un gain en vitesse, mais nécessite le double de ressources.

### 4.2 Technique de retiming

La technique de retiming permet de réduire les délais du chemin critique et de réduire la consommation d’énergie du système. Ainsi, on déplace des délais pour obtenir une meilleure performance pour la consommation des ressources et la fréquence de l’horloge. Les registres sont donc déplacés en amont des blocs logiques pour diminuer les délais des chemins critiques (foward retiming). D’autres registres seront déplacés pour réduire la latence et seront donc placé en aval des blocs logiques (backward retiming). 

Voici les étapes pour mieux comprendre les déplacements des délais :

![image](https://github.com/user-attachments/assets/158f2899-4b3a-430b-aef9-5f5fa644137b)

![image](https://github.com/user-attachments/assets/ab5d4fb0-8cde-4618-9de3-e3fc6fb9ea26)

Voici le schéma pour la technique de retiming avec le chemin critique :

![image](https://github.com/user-attachments/assets/c7fe5ca6-6058-4de9-8251-0559cc649e76)

Voici le rapport des ressources avec l’application de la technique de retiming :

![image](https://github.com/user-attachments/assets/dafccb26-3f08-4760-8374-9e4d6f9b6730)

On peut voir que chaque multiplicateur utilise des DSPs avec une consommation uniforme pour les opérations arithmétiques. Les additions/soustractions consomment uniquement des LUTs. Les délais consomment principalement des LUTs et des registres. La ressource principale du design global, FIR_LMS_3_2, utilise 505 LUTs et 512 registres, sans aucune utilisation de BRAMs. Contrairement au relaxed-lookahead avec 473 LUTs et 400 registres. L’optimisation avec la technique de retiming est donc environ deux fois et demi les valeurs en ressources du système non optimisé (192 LUTs et 208 registres).

Voici le rapport des timings avec l’application de la technique de retiming :

![image](https://github.com/user-attachments/assets/e0fe7b97-eef4-4cf2-8cc1-468a21db918e)

Le chemin critique prend environ 15,22 ns avec 34,62 ns de slack. C’est donc légèrement plus long qu’avec la technique de relaxed-lookahed qui prend 11,26 ns et légèrement plus long que le chemin critique du circuit sans optimisation qui prenait 14,65 ns. Ainsi, la technique de retiming nécessiterait peut-être plus d’optimisation, comme elle semble nécessiter davantage de ressources et de temps pour le chemin critique que la technique de relaxed-lookahead. Cette technique est vraiment très complexe et il fut assez difficile de trouver les bons réaménagements de délais pour maintenir les formes de signaux. De plus, nous avons rencontré fréquemment l’erreur du logiciel de System Generator for DSP pour l’exportation des rapports, ce qui était extrêmement énergivore en terme de temps. 

Voici une comparaison des résultats de simulation entre les deux techniques d’optimisation et le FIR-LMS sans optimisation :

![image](https://github.com/user-attachments/assets/487f8071-9d75-48b9-8eb1-4c9872dbbb05)

On peut donc voir que dans les trois cas, les signaux ont la même tendance. La référence demeure toujours la même. L’erreur converge à des vitesses différentes. Les poids de convergences sont plus élevés avec la technique de relaxed-lookahead en générale, mais avec le temps, les poids de convergence se stabilisent et plus l’erreur est faible. 

## 5. Implémentation vers un FPGA

Pour implémenter le filtre FIR-LMS sur un FPGA tel qu’un Zynq, il faut générer le design dans le format IP Catalog à partir du bloc System Generator dans Simulink, puis importer l’IP dans le catalogue de Vivado pour pouvoir l’utiliser dans un projet. Il faut ensuite faire les connections dans Vivado avec le IP integrator puis générer le bitstream. On exporte ensuite le design vers SDK pour programmer le FPGA. Les coûts logiciels sont donc ceux des outils (System Generator for DSP (incluant MATLAB), Vivado et SDK) et du temps requis pour la programmation, le débogage et les essais.

## Conclusion

En conclusion, nous avons réalisé le développement et la validation d’un filtre FIR-LMS sur FPGA à l’aide de MATLAB et System Generator for DSP. Nous avons également pu faire l’optimisation de ce filtre avec les techniques de relaxed-lookahead et de retiming. Puis, nous avons pu accroître nos connaissances en faisant la gestion du projet dans un dépôt GitHub. Ce projet aura donc permis de faire l’exploration du filtre FIR-LMS avec la System Generator for DSP et de comparer ces résultats avec les précédents laboratoires sur Vivado HLS et HDL. 


# Pratiques de publication du code  

## Versions et publications du code  
- Le code source sera versionné en utilisant les tags GitHub et les GitHub Releases.  
- Les mises à jour majeures seront taguées comme `v1.x`, `v2.x`, tandis que les corrections mineures seront marquées comme `v1.x.x`.  

## Gestion des dysfonctionnements du code  
- Les bugs seront suivis via **GitHub Issues**.  
- Tout problème signalé sera traité en priorité en suivant ces étapes :  
  1. Reconnaître le problème via GitHub.  
  2. Enquêter et reproduire le problème.  
  3. Publier un correctif dans une nouvelle version.  

## Alternatives pour la publication du code  
- **Publication manuelle** : Le code est téléchargé périodiquement après des mises à jour importantes.  
- **Intégration Continue (CI)** : Automatisation des publications avec **GitHub Actions** pour garantir des versions stables et fonctionnelles.  

## Responsabilités du mainteneur  
- En tant que responsable, je m’engage à :  
  - Maintenir le code à jour et stable.  
  - Répondre aux bugs signalés par la communauté via des correctifs ou des améliorations.  
  - Faciliter les contributions et collaborer à la résolution des problèmes.  

