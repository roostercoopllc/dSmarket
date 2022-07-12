<template>
  <v-container>
    <p>// close init connect</p>
    <vue-metamask ref="metamask" :initConnect="false"></vue-metamask>
    
    <p>// click button call Init</p>
    <v-btn @click="connect">connect</v-btn>
  </v-container>
</template>

<script>
  import VueMetamask from 'vue-metamask';

  export default {
    components: {
      VueMetamask,
    },
    data: () => ({
        msg: "This is demo net work"
    }),
    methods:{
      onComplete(data){
        console.log('data:', data);
      },
      connect() {
        this.$refs.metamask.init();
      }
    }
  }
</script>

<style>

</style>