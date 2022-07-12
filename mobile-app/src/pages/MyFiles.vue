<template>
  <v-container>
    <v-container>
      <v-row><h3>File Management</h3></v-row>
      <ipfs-example></ipfs-example>
    </v-container>
    
    <v-container>
      <v-row><h3>File Viewer</h3></v-row>
    </v-container>
    
    <v-container>
      <v-row><h3>File Auditing</h3></v-row>
    </v-container>

    <v-dialog
        v-model="dialog"
        width="500"
      >
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            color="red lighten-2"
            dark
            v-bind="attrs"
            v-on="on"
          >
            Click Me
          </v-btn>
        </template>

        <v-card>
          <v-card-title class="text-h5 grey lighten-2">
            Privacy Policy
          </v-card-title>

          <v-card-text>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
          </v-card-text>

          <v-divider></v-divider>

          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn
              color="primary"
              text
              @click="dialog = false"
            >
              I accept
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
  </v-container>
</template>

<script>
import IpfsExample from '../components/IPFSExample.vue'

export default {
  data: () => ({
    pdf: null,
    page: 1,
    dialog: false
  }),
  components: {
    IpfsExample
  },
}
</script>

<style scoped>

</style>