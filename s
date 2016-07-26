[33mcommit b6176925e692af54f998c930999ce22a58eb97d3[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Thu Jul 21 09:38:08 2016 -0700

    improve windows error messages to improve #97

[33mcommit 2d0c7320c7738fd9c1f71ac0389142a58b762dd6[m
Merge: d3cc631 9ab95f8
Author: JJ Allaire <jj.allaire@gmail.com>
Date:   Thu Jul 21 11:55:20 2016 -0400

    Merge pull request #9 from rstudio/feature/backend-fork
    
    transition sparkapi to use its own backend fork

[33mcommit 9ab95f89d50cd0e7ac31d194a69f7d3988fa798a[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Wed Jul 20 22:40:41 2016 -0700

    move app_jar parameter to config as sparkapi.app.jar

[33mcommit 16b0a2643144cc9252787e3d8cbb815763cae1f9[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Wed Jul 20 16:34:41 2016 -0700

    normalize applciation jar and use shell instead of system2 in windows #86

[33mcommit 97b21bd78923a5bbedcd12b04d84870863613743[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Wed Jul 20 15:52:21 2016 -0700

    rebuild sparkapi jar

[33mcommit 75620d15aa0e19087fe69062091ca1e8d175eab8[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Wed Jul 20 15:51:37 2016 -0700

    remove all references to sparkr

[33mcommit b90cf6809e8d6761ef1ae8ff896af3f57e065a6c[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Wed Jul 20 15:47:03 2016 -0700

    make sparkapi default backend

[33mcommit a0c3abba732063bea4fcfcf5cc66f581bd1de82d[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Wed Jul 20 15:46:45 2016 -0700

    rebuild sparkapi jar

[33mcommit e3b2b53d7539884b8046a050e42cd35c90026469[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Wed Jul 20 15:46:29 2016 -0700

    remove references to spark.api.r

[33mcommit ffc2301f8268aad3c00d37f258b9f3fde8736df3[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Wed Jul 20 13:53:08 2016 -0700

    cleanup files, names and references

[33mcommit 24c611387631e49aae270268db5c269b8f474424[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Wed Jul 20 13:43:56 2016 -0700

    use well defined spark directory instead of using sparklyr helpers

[33mcommit b507c2b7bcbcabf446a62b07872e9d9f5a6fc79f[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Wed Jul 20 12:18:49 2016 -0700

    port work from sparklyr repo feature/spark-backend branch

[33mcommit d3cc631e93e280753d3eacf4eb54318b4a5dbb06[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Wed Jul 20 19:22:11 2016 -0400

    add sas7bdat package as example

[33mcommit 4243cc306be03e483710245386dbaf03f008a7fc[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Tue Jul 19 13:58:57 2016 -0700

    add sparkapi.ports.wait.seconds config to reduce wait time

[33mcommit 0df42b32a2972f22b93a51b7c9ed94d28d1150a3[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Mon Jul 18 16:14:31 2016 -0700

    Add support to pass an arbitrary jar through to spark-submit

[33mcommit 938776cbbbf3238de2f53f47faa9a353448dfa03[m
Merge: 22b972f 66aa536
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Mon Jul 18 12:03:03 2016 -0700

    Merge pull request #4 from lepennec/master
    
    remove duplicate suggests field in description

[33mcommit 22b972f4dbad848309f96ad7e5026ba001986070[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Fri Jul 15 15:01:57 2016 -0700

    initialize and add java_context

[33mcommit 6edd838c8e9beb1d6fb67fecfc4fdb51475409e4[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Tue Jul 12 11:14:59 2016 -0700

    avoid normalizing path for custom path to ports file

[33mcommit e0682023e0526764884adf19412fc1c2c744ad20[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Mon Jul 11 16:44:52 2016 -0700

    use default in getOptions

[33mcommit 329b9f93b354f9a2a042d6494f5d253df60b1337[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Mon Jul 11 16:12:19 2016 -0700

    add support for option sparkapi.ports.file to allow users to configure ports file location

[33mcommit 2934af2d788ac2c959b188eda8ed69f335869ce2[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Mon Jul 11 07:46:23 2016 -0400

    add docs on start and stop shell

[33mcommit ed670b8226541fa4dfc05592cbf20a6b46dd3718[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Mon Jul 11 07:42:26 2016 -0400

    add docs for spark_version function

[33mcommit 6bec915e63c0d5996751ead76f47e59002ec66d5[m
Merge: 469c90f 4420f62
Author: JJ Allaire <jj@rstudio.org>
Date:   Sat Jul 9 05:43:03 2016 -0400

    Merge branch 'master' of github.com:rstudio/sparkapi

[33mcommit 469c90f1e5185569fcc9e89e816a5b7637da333d[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Sat Jul 9 05:42:57 2016 -0400

    pass scala version to spark_dependencies

[33mcommit 4420f626a86edb0088a16be55897cb4bfcb418c4[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Fri Jul 8 17:40:36 2016 -0700

    fix typo in session prefix

[33mcommit 15e94533548177e56a8fa372f64d207c7dcdeb62[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Fri Jul 8 17:23:34 2016 -0700

    bump version to 0.3.12

[33mcommit af5f0ed2e88594d5dd5759aa190bae12c1e6baac[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Fri Jul 8 17:23:23 2016 -0700

    regenerate docs

[33mcommit d56d1fb7ae151ec524f6393e3d0f143052730861[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Fri Jul 8 17:23:12 2016 -0700

    remove spark.session config parameter since session params use spark.sql

[33mcommit 1e68a21775c495a07df8f416ce1c29f1c6658f77[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Fri Jul 8 17:22:44 2016 -0700

    fix cast to character while applying settings, fix prefixes

[33mcommit 092c8079ecde85b25955df2f86a0dc0ca87eb6f9[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Fri Jul 8 08:47:50 2016 -0700

    filter out spark.sql and spark.session while retrieving spark. config

[33mcommit 27e04b005b54f6da1f8ba98a44f39cd3e8895338[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Fri Jul 8 08:42:29 2016 -0700

    add support to filter out prefixes in connection_config

[33mcommit d6c06e041309977148397bf1b11380b895b4d5af[m
Merge: 530e8df 4be0716
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Fri Jul 8 08:41:44 2016 -0700

    Merge pull request #7 from dselivanov/master
    
    Fixes bug when `initialize_connection()` doesn't pass parameters to spark initialization routine.

[33mcommit 530e8df56f9c66a3c5b30c3e4ced6b375bd123ad[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Fri Jul 8 11:37:14 2016 -0400

    allow for automatic inclusion of extensions based on registration

[33mcommit 9ff769604fa2d9ecfb50a173233b84689578c9a0[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Fri Jul 8 10:15:33 2016 -0400

    bump version

[33mcommit bbebf2066b6dd7af8b746decfbc6228775783560[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Fri Jul 8 08:51:22 2016 -0400

    allow null for jars or packages in spark_dependency

[33mcommit 4be071621e6a50d1b307f0fd4dff256620323bec[m
Author: Dmitriy Selivanov <selivanov.dmitriy@gmail.com>
Date:   Fri Jul 8 13:35:53 2016 +0300

    Fixes bug when `initialize_connection()` doesn't pass parameters to spark initialization routine.

[33mcommit a06f6bb6aef83132503fa58948a06ee47de3d024[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Thu Jul 7 14:38:35 2016 -0700

    bump version to 0.3.9

[33mcommit e402d280be427dde3e0703d3d0b51c983ba2b65b[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Thu Jul 7 14:38:07 2016 -0700

    use spark_log in spark_web to ensure spark_web uses subclassed version of spark_log

[33mcommit b5c9a79d341cad43be11f03f75c9121bb7190fc1[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Thu Jul 7 09:33:36 2016 -0700

    add support for user names with spaces

[33mcommit 1a04337f70a4b762ee83e33f98f5d1935acd08a5[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Thu Jul 7 08:47:36 2016 -0700

    allow jars or packages to be empty

[33mcommit d5ea543b31d05c5b6baff87fa95fe6dbd58e40cb[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Thu Jul 7 09:44:16 2016 -0400

    allow explicit passing of spark_home to spark_shell

[33mcommit 89070424f703a2cb1da6fed5404ae9618687b5b3[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Thu Jul 7 09:32:30 2016 -0400

    require prefix for connection_config function

[33mcommit 14fe767b11eb8f44f482ba273d95eb5ad362bbc8[m
Merge: 117e2dc 3e74f5b
Author: JJ Allaire <jj.allaire@gmail.com>
Date:   Thu Jul 7 05:41:11 2016 -0400

    Merge pull request #6 from javierluraschi/feature/windows
    
    enable start_shell for windows

[33mcommit 3e74f5b44d465c3de4a9652175b8edd959b14c20[m
Author: Javier Luraschi <javierluraschi@hotmail.com>
Date:   Wed Jul 6 22:34:49 2016 -0700

    enable start_shell for windows

[33mcommit 117e2dcf1babfe5cb5519d76380b7f2e862ae667[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Wed Jul 6 17:01:49 2016 -0400

    update sparkapi package

[33mcommit 24bd04876890bdb24348484704e3f793b0f626be[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Wed Jul 6 11:14:56 2016 -0400

    update README

[33mcommit bb9b75c1cf454d54a783c27e6f86d78e5c61a401[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Wed Jul 6 09:58:37 2016 -0400

    rename read_config to connection_config

[33mcommit bfe1a9cf66c5d6cf72311ed372eb91095ed24e75[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Wed Jul 6 09:41:41 2016 -0400

    provide defaults for spark_home and app_name

[33mcommit 6f1d376b742114728a528e6c2b6ad2f121484756[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Wed Jul 6 09:39:55 2016 -0400

    don't transform master

[33mcommit 53e0c3777204b466c6abe533b1d225d42fb052c4[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Wed Jul 6 09:18:41 2016 -0400

    add hive_context to api

[33mcommit 7ccb5b67a4e6549b4dff8643d4b202bd30e20106[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Wed Jul 6 08:00:11 2016 -0400

    factor out connection initialization

[33mcommit f8119924f8c0aa4d264aca48ff58db050dd2e8b0[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Wed Jul 6 07:39:57 2016 -0400

    add spark_version function

[33mcommit 73bd6794fd502bb3cdd58e0a4bc206d91f1fdee9[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Wed Jul 6 07:26:28 2016 -0400

    add ... to generic signatures

[33mcommit 28c4bb5a099965227e2e0268dde6e2b17dd25a89[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Wed Jul 6 06:47:09 2016 -0400

    rename some api functions

[33mcommit 131cb43fc19dd69c84b4ea3759dc50826ca40bb2[m
Author: JJ Allaire <jj@rstudio.org>
Date:   Tue Jul 5 16:56:45 2016 -0400

    move shell functions to sparkapi package

[33mcommit 6ad0bdc48555a8adee65fcd0a6c7fd048525a509[m
Merge: 1761464 145461a
Author: JJ Allaire <jj@rstudio.org>
Date:   Tue Jul 5 07:44:52 2016 -0400

    merge from master
    
    Merge remote-tracking branch 'origin/master' into feature/shell-functions
    
    Conflicts:
    	R/dependency.R
    	man/spark_dependencies.Rd
