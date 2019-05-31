<template>
  <div v-if="result">
      <h4 class="card-title ml-2">
        <icon class="mb-1 mr-1" name="users"/>
        {{ result.name }}
      </h4>

    <div v-if="!result.locations.length" class="card mt-2">
      <div class="card-body">
        <b-list-group-item class="bg-light">
          {{ $t('no_info_available') }}
        </b-list-group-item>
      </div>
    </div>

    <div v-if="result.locations.length" class="card mt-2 mb-2">
      <div class="card-body">
        <b-list-group-item class="mb-2 bg-light">
          {{ $t('contact_info') }}
        </b-list-group-item>
        <template v-if="result.locations && result.locations.length">
          <b-list-group-item
            v-for="(location, index) in result.locations" :key="Object.keys(location)[index]"
            :class="!getIcon(location[1]) ? 'empty' : ''"
          >
            <template v-if="getIcon(location[1])">
              <icon  class="mb-1" :name="getIcon(location[1])"/>
              <span class="col">{{ location[3] }}</span>
            </template>
          </b-list-group-item>
        </template>
      </div>
    </div>

    <div class="card mt-2">
      <div class="card-body">
        <b-list-group-item class="bg-light">
          {{ $t('department') }}
        </b-list-group-item>
        <b-list-group-item class="mt-2">
          <v-tree-view/>
        </b-list-group-item>
      </div>
    </div>

    <div v-if="result.managers.length" class="card mt-2">
      <div class="card-body">
          <b-list-group-item class="bg-light">
            {{ $t('managers') }}
          </b-list-group-item>
           <b-list-group class="mt-2" v-for="manager in result.managers" :key="manager[2]">
          <b-list-group-item>
            <router-link :to="{ name: 'person', params: { uuid: manager[2] } }">
              {{manager[1]}}
            </router-link>
          </b-list-group-item>
          <b-list-group-item>
            {{manager[0]}}
          </b-list-group-item>
          </b-list-group>
      </div>
    </div>

    <div v-if="result.employees.length" class="card mt-2">
      <div class="card-body">
          <b-list-group-item class="bg-light">
            {{ $t('employees') }}
          </b-list-group-item>
          <b-list-group class="mt-2" v-for="employee in result.employees" :key="employee[1]">
          <b-list-group-item>
            <router-link :to="{ name: 'person', params: { uuid: employee[1] } }">
              {{employee[0]}}
            </router-link>
          </b-list-group-item>
          <b-list-group-item>
            {{employee[2]}}, {{employee[3]}}
          </b-list-group-item>
          </b-list-group>
      </div>
    </div>

    <div v-if="result.associated.length" class="card mt-2">
      <div class="card-body">
          <b-list-group-item class="bg-light">
            {{ $t('associated') }}
          </b-list-group-item>
           <b-list-group class="mt-2" v-for="associated in result.associated" :key="associated[1]">
          <b-list-group-item>
            <router-link :to="{ name: 'person', params: { uuid: associated[1] } }">
              {{associated[0]}}
            </router-link>
          </b-list-group-item>
          <b-list-group-item>
            {{associated[2]}}, {{associated[3]}}
          </b-list-group-item>
          </b-list-group>
      </div>
    </div>

    <div class="card mt-2 mb-2">
      <div class="card-body">
          <b-list-group-item class="bg-light">
            Opgaver
          </b-list-group-item>
          <b-list-group-item class="mt-2">
            Ferieydelse optjent under barsel (34.30.10)
          </b-list-group-item>
          <b-list-group-item class="mt-2">
            Ferieydelse optjent under barsel (37.20.19)
          </b-list-group-item>
      </div>
    </div>
  </div>
</template>

<script>
import VTreeView from '@/components/VTreeView'
import GetIcon from '@/mixins/GetIcon'
import Search from '@/api/Search'

export default {
  name: 'VDetailOrganisation',

  mixins: [GetIcon],

  components: {
    VTreeView
  },

  data () {
    return {
      result: null
    }
  },

  props: {
    uuid: String
  },

  methods: {
    setData (payload) {
      this.result = payload
    }
  },

  beforeRouteEnter (to, from, next) {
    Search.departments('uuid', to.params.uuid)
      .then(res => {
        const parsedRes = JSON.parse(res.response.docs[0].document)
        next(vm => vm.setData(parsedRes))
      })
  },

  beforeRouteUpdate (to, from, next) {
    Search.departments('uuid', to.params.uuid)
      .then(res => {
        const parsedRes = JSON.parse(res.response.docs[0].document)
        this.setData(parsedRes)
        next()
      })
  }
}
</script>

<style scoped>
.header-item {
    font-size: 1.2em;
}
.list-group-item.empty {
  display: none;
}
</style>
