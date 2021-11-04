import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

import App from './App.vue'
import Body from './components/body.vue'
import Reading from './components/reading.vue'
import Vuetify from 'vuetify'
import vuetify from '@/plugins/vuetify'

Vue.config.productionTip = false
Vue.use(Vuetify)

const routes = [
  { path: '/reader', component: Reading },
  { path: '/', component: Body }
]

const router = new VueRouter({
  mode: 'history',
  routes: routes
})

import './sass/main.css'
new Vue({
  router: router,
  render: h => h(App),
  vuetify: vuetify
}).$mount('#app')
