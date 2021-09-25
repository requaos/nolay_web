<template>
  <v-app id="app">
    <Header></Header>
    <Body></Body>
  </v-app>
</template>

<script>
//import HelloWorld from './components/HelloWorld.vue'
import 'vuetify/dist/vuetify.min.css'
import Header from './components/header.vue'
import Body from './components/body.vue'

export default {
  name: 'App',
  components: {
    Header,
    Body
  },
}
</script>