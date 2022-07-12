<template>
  <div>
    <h3>{{ status }}</h3>
    <div v-if="online" class="ipfs-info">
      <h3>
        ID: <span id="ipfs-info-id">{{ id }}</span>
      </h3>
      <h3>
        Agent version: <span id="ipfs-info-agent">{{ agentVersion }}</span>
      </h3>
    </div>
  </div>
</template>

<script>
export default {
  name: "IpfsInfo",
  data: function() {
    return {
      status: "Connecting to IPFS...",
      id: "",
      agentVersion: "",
      online: false
    };
  },
  mounted: () => {
    this.getIpfsNodeInfo();
  },
  methods: {
    getIpfsNodeInfo() {
      console.log('am I firing?')
      try {
        console.log('I am in the try block')
        // Await for ipfs node instance.
        new Promise((resolve, reject) => {
          ipfs.once('ready', () => {
            console.log('I am in the promise block');
          });
        }).then(() => {
          console.log()
          resolve();
        });
        const ipfs = await this.$ipfs;
        // Call ipfs `id` method.
        // Returns the identity of the Peer.
        const { agentVersion, id } = await ipfs.id();
        this.agentVersion = agentVersion;
        this.id = id;
        // Set successful status text.
        this.status = "Connected to IPFS =)";
        this.online = ipfs.isOnline();
      } catch (err) {
        // Set error status text.
        this.status = `Error: ${err}`;
      }
    }
  }
};
</script>
