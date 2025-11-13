<template>
  <div ref="map" style="width: 100%; height: 100%;"></div>
</template>

<script>
import { onMounted, ref } from "vue";

export default {
  name: "NeshanMap",
  setup() {
    const map = ref(null);

    onMounted(() => {
      const myMap = new L.Map(map.value, {
        key: "YOUR_NESHAN_API_KEY",
        maptype: "dreamy",
        poi: true,
        traffic: false,
        center: [35.699, 51.338],
        zoom: 14,
      });
      const marker = L.marker([35.699, 51.338]).addTo(myMap);
    });

    return {
      map,
    };
  },
};
</script>
