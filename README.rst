Om OS2PhoneBook
===============

Dette er en simpel telefonbog, der henter sine data fra OS2MOs API.

Usage
-----
Start applicationen op med:

.. code-block:: console

    $ docker-compose up --build

Load data ind, vha. :code:`curl`:

.. code-block:: console

    $ curl -u dataloader:password1 -X POST \
           -H "Content-Type: application/json" \
           -d @dev-environment/snapshot/employees.json \
           localhost:9090/api/load-employees
    {"indexed":758,"total":758}

    $ curl -u dataloader:password1 -X POST \
           -H "Content-Type: application/json" \
           -d @dev-environment/snapshot/org_units.json \
           localhost:9090/api/load-org-units
    {"indexed":62,"total":62}


Licens og Copyright
-------------------

Copyright (c) 2018, Magenta ApS.

Dette værk er frigivet under `Mozilla Public License, version 2.0
<https://www.mozilla.org/en-US/MPL/>`_, som gengivet i ``LICENSE``. 

Dette er et OS2-projekt. Ophavsretten tilhører de individuelle bidragydere.

