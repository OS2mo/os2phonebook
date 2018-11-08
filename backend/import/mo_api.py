import os

from collections import defaultdict

import requests

from cached_property import cached_property


DEFAULT_MO_URL = os.environ.get(
        'MO_URL', 'http://morademo.atlas.magenta.dk/service'
)
ORG_ROOT = os.environ.get(
    'MO_ORG_ROOT', '293089ba-a1d7-4fff-a9d0-79bd8bab4e5b'
)


def mo_get(url):
    """Helper function for getting data from MO.

    Return JSON content if successful, throw exception if not."""
    result = requests.get(url)
    if not result:
        result.raise_for_status()
    else:
        return result.json()


class MOData:
    """Abstract base class to interface with MO objects."""

    @cached_property
    def json(self):
        return mo_get(self.url)

    @cached_property
    def children(self):
        return mo_get(self.url + '/children')

    @cached_property
    def _details(self):
        return mo_get(self.url + '/details/')

    @cached_property
    def detail_fields(self):
        return list(self._details.keys())

    def _get_detail(self, detail):
        return mo_get(self.url + '/details/' + detail)

    def __getattr__(self, name):
        """Get details if field in details for object.

         Available details for OrgFunc are: address, association,
         engagement, it, leave, manager, org_unit, role
         """
        if name in self._details:
            if name not in self._stored_details and self._details[name]:
                self._stored_details[name] = self._get_detail(name)
            return self._stored_details[name]
        else:
            return object.__getattribute__(self, name)

    def __str__(self):
        return str(self.json)

    def __init__(self, uuid):
        self.uuid = uuid
        self._stored_details = defaultdict(list)


class MOOrgUnit(MOData):
    """A MO organisation unit, e.g. a department in a municipality."""

    def __init__(self, uuid, mo_url=DEFAULT_MO_URL):
        super().__init__(uuid)
        self.url = mo_url + '/ou/' + self.uuid


class MOEmployee(MOData):
    """A MO employee."""

    def __init__(self, uuid, mo_url=DEFAULT_MO_URL):
        super().__init__(uuid)
        self.url = mo_url + '/e/' + self.uuid


def get_ous(org_id=ORG_ROOT, mo_url=DEFAULT_MO_URL):
    """Get all organization units belonging to org_id."""
    return mo_get(mo_url + '/o/' + org_id + '/ou/')['items']


def get_employees(org_id=ORG_ROOT, mo_url=DEFAULT_MO_URL):
    return mo_get(mo_url + '/o/' + org_id + '/e/')['items']


if __name__ == '__main__':
    # Note: This is just a quick smoke test. Will only work if
    # DEFAULT_MO_URL and ORG_ROOT are properly configured.
    ou_uuid = get_ous(ORG_ROOT)[0]['uuid']
    e_uuid = get_employees(ORG_ROOT)[0]['uuid']
    ou = MOOrgUnit(ou_uuid)
    e = MOEmployee(e_uuid)
    print(ou.json['name'])
    print(e.json['name'])