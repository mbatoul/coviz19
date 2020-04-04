<template>
  <div class="section">
    <div class="container is-fluid">
      <div class="columns is-centered">
        <div class="column is-two-thirds">
          <div class="field is-horizontal">
            <div class="field-label is-normal">
              <label class="label">From</label>
            </div>
            <div class="field-body">
              <div class="field">
                <p class="control is-expanded">
                  <input
                    class="input"
                    :class="{ 'is-danger': $v.name.$error, 'is-success': $v.name.$dirty }"
                    type="text"
                    placeholder="Name"
                    v-model="$v.name.$model"
                  >
                  <span class="help is-danger" v-if="$v.name.$dirty && !$v.name.required">Field is required.</span>
                  <span class="help is-danger" v-if="!$v.name.minLength">Name must have at least {{$v.name.$params.minLength.min}} letters.</span>
                </p>
              </div>
              <div class="field">
                <p class="control is-expanded">
                  <input
                    class="input"
                    :class="{ 'is-danger': $v.emailAddress.$error, 'is-success': $v.emailAddress.$dirty }"
                    type="email"
                    placeholder="Email"
                    v-model="$v.emailAddress.$model"
                  >
                  <span class="help is-danger" v-if="$v.emailAddress.$dirty && !$v.emailAddress.required">Field is required.</span>
                  <span class="help is-danger" v-if="!$v.emailAddress.email">Email address must be valid.</span>
                </p>
              </div>
            </div>
          </div>
          <div class="field-body">
            <div class="field-label is-normal">
              
            </div>
            <div class="error-name">

            </div>
          </div>

          <div class="field is-horizontal">
            <div class="field-label is-normal">
              <label class="label">Subject</label>
            </div>
            <div class="field-body">
              <div class="field">
                <div class="control">
                  <input
                    class="input"
                    :class="{ 'is-danger': $v.subject.$error, 'is-success': $v.subject.$dirty }"
                    type="text"
                    placeholder="e.g. Suggestions, bug report"
                    v-model="$v.subject.$model"
                  >
                  <span class="help is-danger" v-if="$v.subject.$dirty && !$v.subject.required">Field is required.</span>
                  <span class="help is-danger" v-if="!$v.subject.minLength">Subject must have at least {{$v.subject.$params.minLength.min}} letters.</span>
                </div>
              </div>
            </div>
          </div>

          <div class="field is-horizontal">
            <div class="field-label is-normal">
              <label class="label">Message</label>
            </div>
            <div class="field-body">
              <div class="field">
                <div class="control">
                  <textarea
                    class="textarea"
                    :class="{ 'is-danger': $v.message.$error, 'is-success': $v.message.$dirty }"
                    placeholder="Tell us more"
                    v-model="$v.message.$model"
                  >
                  </textarea>
                  <span class="help is-danger" v-if="$v.message.$dirty && !$v.message.required">Field is required.</span>
                  <span class="help is-danger" v-if="!$v.message.minLength">Message must have at least {{$v.message.$params.minLength.min}} letters.</span>
                </div>
              </div>
            </div>
          </div>

          <div class="field is-horizontal">
            <div class="field-label">
            </div>
            <div class="field-body">
              <div class="field">
                <div class="control">
                  <button class="button is-primary" v-on:click='submit'>
                    Send
                  </button>
                  <p class="help is-success" v-if="submitStatus === 'success'">Your message was successfully sent! I will get in touch very soon.</p>
                  <p class="help is-danger" v-if="submitStatus === 'error'">Please fill the form correctly.</p>
                  <p class="help" v-if="submitStatus === 'pending'">Sending...</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { required, minLength, email } from 'vuelidate/lib/validators'

export default {
  data () {
    return {
      name: null,
      emailAddress: null,
      phoneNumber: null,
      subject: null,
      message: null,
      submitStatus: null
    }
  },

  validations: {
    name: {
      required,
      minLength: minLength(4)
    },
    emailAddress: {
      required,
      email
    },
    subject: {
      required,
      minLength: minLength(5)
    },
    message: {
      required,
      minLength: minLength(5)
    },
  },

  methods: {
    submit() {
      this.$v.$touch()

      if (this.$v.$invalid) {
        this.submitStatus = 'error'
      } else {
        this.postContact();
        this.submitStatus = 'pending'
        setTimeout(() => {
          this.submitStatus = 'success'
        }, 500)
      }
    },

    postContact: async function () {
      try {
        const response = await this.$http.post(
          '/contact.json',
          {
            name: this.name,
            email: this.emailAddress,
            subject: this.subject,
            message: this.message
          }
        );
        console.log(response);
      } catch (error) {
        console.error(error);
      }
    }
  }
}
</script>