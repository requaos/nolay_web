<template>
  <v-app id="app">
    <Header></Header>
    <router-view></router-view>
  </v-app>
</template>

<script>
import 'vuetify/dist/vuetify.min.css'
import Header from './components/header.vue'

export default {
  name: 'App',
  components: {
    Header
  },
}
</script>