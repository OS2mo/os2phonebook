<template>
  <div>
      <h4 class="card-title ml-2">
        <icon class="mb-1 mr-1" name="user"/>
        {{result.name}}
      </h4>

    <div v-if="!result.locations.length && !result.departments.length" class="card mt-2">
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
        <b-list-group-item v-for="(location, index) in result.locations" :key="Object.keys(location)[index]">
          <icon  class="mb-1" v-if="getIcon(location[1])" :name="getIcon(location[1])"/>
          <span class="col">{{ location[3] }}</span>
        </b-list-group-item>
      </div>
    </div>

    <div v-if="result.departments.length" class="card mt-2 mb-2">
      <div class="card-body">
        <b-list-group-item class="bg-light">
          {{ $t('job_title') }}
        </b-list-group-item>
        <b-list-group class="mt-2" v-for="department in result.departments" :key="department[1]">
          <b-list-group-item>
              {{department[2]}}
          </b-list-group-item>
          <b-list-group-item>
            {{department[3]}}
          </b-list-group-item>
        </b-list-group>
      </div>
    </div>

    <div v-if="result.departments.length" class="card mt-2 mb-2">
      <div class="card-body">
        <b-list-group-item class="bg-light">
          {{ $t('department') }}
        </b-list-group-item>
        <b-list-group class="mt-2" v-for="department in result.departments" :key="department[1]">
          <b-list-group-item>
            <router-link class="link-color" :to="{ name: 'organisation', params: { uuid: department[1] } }">
              {{department[0]}}
            </router-link>
          </b-list-group-item>
        </b-list-group>
      </div>
    </div>

    <div v-if="result.managing.length" class="card mt-2 mb-2">
      <div class="card-body">
        <b-list-group-item class="bg-light">
          {{ $t('managing') }}
        </b-list-group-item>
        <b-list-group class="mt-2" v-for="manager in result.managing" :key="manager[1]">
          <b-list-group-item>
            <router-link :to="{ name: 'organisation', params: { uuid: manager[1] } }">
              {{manager[0]}}
            </router-link>
          </b-list-group-item>
          <b-list-group-item>
            {{manager[2]}}
          </b-list-group-item>
        </b-list-group>
      </div>
    </div>

    <div v-if="result.associated.length" class="card mt-2 mb-2">
      <div class="card-body">
        <b-list-group-item class="bg-light">
          {{ $t('associated_departments') }}
        </b-list-group-item>
        <b-list-group class="mt-2" v-for="associated in result.associated" :key="associated[1]">
          <b-list-group-item>
            <router-link :to="{ name: 'organisation', params: { uuid: associated[1] } }">
              {{associated[0]}}
            </router-link>
          </b-list-group-item>
          <b-list-group-item>
            {{associated[2]}}, {{associated[3]}}
          </b-list-group-item>
        </b-list-group>
      </div>
    </div>
  </div>
</template>

<script>
import GetIcon from '@/mixins/GetIcon'

export default {
  name: 'VDetailPerson',

  mixins: [GetIcon],

  props: {
    uuid: String,
    result: Object
  }
}
</script>

<style scoped>
.header-item {
  font-size: 1.2em;
}
</style>
