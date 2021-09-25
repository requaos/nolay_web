<template>
    <v-container>
      <v-row
        :justify="'center'"
        style="height: 500px;"
      >
        <v-col
          :key="1"
          :align-self="'end'"
          md="4"
        >

        <Dialog></Dialog>
          
        </v-col>
      </v-row>
    </v-container>
</template>

<script>
import Dialog from './dialog.vue'

export default {
  name: 'Body',
  components: {
    Dialog
  }
}
</script>



