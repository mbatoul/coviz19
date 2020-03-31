<template>
  <div class="section">
    <div class='container is-fluid'>
      <div class="columns is-centered">
        <div class="column is-two-thirds">
          <div class="title">
            {{ capitalize(nature) }}
            <div
              class="loading small"
              v-show='isLoading'
            >
            </div>
          </div>
          <b-field grouped group-multiline>
            <b-select v-model="perPage" :disabled="!isPaginated">
              <option value="20">20 per page</option>
              <option value="50">50 per page</option>
              <option value="75">75 per page</option>
              <option value="100">100 per page</option>
            </b-select>
            <div class="control is-flex">
              <b-switch v-model="isPaginated">Paginated</b-switch>
            </div>
          </b-field>
          
          <transition name='fade'>
            <b-table
              v-if='!isLoading'
              :data="rawData"
              :paginated="isPaginated"
              :per-page="perPage"
              :current-page.sync="currentPage"
              :pagination-position="paginationPosition"
              :default-sort-direction="defaultSortDirection"
              :sort-icon="sortIcon"
              :sort-icon-size="sortIconSize"
              default-sort="user.first_name"
              aria-next-label="Next page"
              aria-previous-label="Previous page"
              aria-page-label="Page"
              aria-current-label="Current page"
            >
              <template slot-scope="props">
                <b-table-column v-if="nature !== 'country'" field="child_name" label="Region" sortable searchable>
                  {{ props.row.child_name }}
                </b-table-column>

                <b-table-column field="parent_name" label="Country" sortable searchable>
                  {{ props.row.parent_name }}
                </b-table-column>

                <b-table-column field="active" label="Active cases" sortable numeric>
                  {{ props.row.active }}
                </b-table-column>

                <b-table-column field="confirmed" label="Confirmed cases" sortable numeric>
                  {{ props.row.confirmed }}
                </b-table-column>

                <b-table-column field="death" label="Deaths" sortable numeric>
                  {{ props.row.death }}
                </b-table-column>

                <b-table-column field="recovered" label="Recovered" sortable numeric>
                  {{ props.row.recovered }}
                </b-table-column>
              </template>
            </b-table>
          </transition>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import StringFormatter from '../mixins/string-formatter.js';

export default {
  props: {
    nature: {
      type: String,
      required: true
    }
  },

  mixins: [
    StringFormatter
  ],

  data () {
    return {
      rawData: [],
      isLoading: false,
      isPaginated: true,
      paginationPosition: 'bottom',
      defaultSortDirection: 'desc',
      sortIconSize: 'is-small',
      currentPage: 1,
      perPage: 20,

    }
  },

  computed: {
    parentOnly: function () {
      return this.nature === 'countries';
    }
  },

  watch: {
    nature: function () {
      this.getRawData();  
    }
  },

  mounted () {
    this.getRawData();
  },

  methods: {
    getRawData: async function () {
      this.isLoading = true;
      try {
        const response = await this.$http.get(
          `/zones/raw-data.json`,
          {
            params: {
              parent_only: this.parentOnly
            }
          }
        )
        this.rawData = response.data.raw_data;
        this.isLoading = false;
      } catch (error) {
        console.error(error);
      }
    }
  }
}
</script>

<style scoped>
  .loading.small {
    display: inline-block;
    position: absolute;
    right: -50px;
    top: 0;
  }

  .title {
    display: inline-block;
    position: relative;
  }
</style>
