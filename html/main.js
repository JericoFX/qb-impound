const { ref, onMounted, watchEffect, onUnmounted, computed } = Vue;
const { useQuasar } = Quasar;
const app = Vue.createApp({
  setup () {
    const Log = (message) => {
      return console.log(JSON.stringify(message))
    }
    const text = ref("");
    const show = ref(false);
    const plate = ref("");
    const img = ref("");
    const $q = useQuasar()
    const medium = ref(false)
    const vehicle = ref(null)
    const Player = ref({
      name: String,
      phone: Number,
      citizenid: String
    })
    const Gnames = ref([])
    const GaragesIndex = ref(null)
    const GarageNames = ref("")

    const Jerico = (e) => {
      e.preventDefault();
      const Data = e.data;
      show.value = Data.show;
      plate.value = Data.plate;
      GaragesIndex.value = Data.GaragesIndex
      GarageNames.value = Data.GarageNames
      vehicle.value = Data.vehicle
      Pdata()
    };

    const Pdata = () => {
      for (const key in GaragesIndex.value) {
        if (Object.hasOwnProperty.call(GaragesIndex.value, key)) {
          const element = GaragesIndex.value[key];
          for (const key in GarageNames.value) {
            if (Object.hasOwnProperty.call(GarageNames.value, key)) {
              const element2 = GarageNames.value[key];
              Gnames.value.push({ label: element2, value: element, color: 'secondary' })
            }
          }
        }
      }
    }

    const radio = () => {
      $q.dialog({
        title: 'Options',
        dark:true,
        message: `Select where you want to send the vehicle with the plate ${plate.value}`,
        options: {
          type: 'radio',
          model: Gnames.value[0].value,
          // inline: true
          items: Gnames.value
        },
        persistent: true
      }).onOk(data => {
        SendDataToLua(data)
        Gnames.value = []
      }).onCancel(() => {
        text.value = ""
      }).onDismiss(() => {

      })

    }
    const SendDataToLua = (data) => {
      console.log(text.value);
      axios.post(
        'https://qb-impound/SendDataToLua',
        JSON.stringify({
          img: img.value,
          plate: plate.value,
          notes: text.value,
          garage: data,
          vehicle: vehicle.value
        })
      );
      Gnames.value = []
      text.value = ""
      plate.value = ""
      img.value = ""
      vehicle.value = null
      ByeBye()
    };



    onMounted(() => {
      window.addEventListener('message', Jerico);
    });

    onUnmounted(() => {
      window.removeEventListener('message', Jerico);
    });

    const ByeBye = () => {
      axios.post('https://qb-impound/ExitApp');
      show.value = false;
    };

    const Push = () => {
  
      axios.post('https://qb-impound/Camera').then(function (resp) {
        img.value = resp.data;
      });
    };

    const GetPlayerData = () => {
      axios.post('https://qb-impound/GetData', JSON.stringify(plate.value)).then(function (resp) {
        Player.value.name = "Name: " + resp.data.name;
        Player.value.phone = "Phone: " + resp.data.phone;
        Player.value.citizenid = resp.data.citizenid;
        medium.value = true;
      });
    }

    return {
      text,
      show,
      plate,
      img,
      ByeBye,
      Push,
      SendDataToLua,
      GetPlayerData,
      medium,
      Player,
      GaragesIndex,
      GarageNames,
      radio,
    };
  },
});

app.use(Quasar);
Quasar.iconSet.set(Quasar.iconSet.mdiV6);
app.mount('#q-app');