@SinglePageLogin.config(
  loginTitle: 'Log In'
  signupTitle: 'Sign Up'
  forgotPasswordTitle: 'Forgot Password'
  canRetrievePassword: true
  passwordSignupFields: 'USERNAME_AND_EMAIL'
  forbidClientAccountCreation: false
  routeAfterLogin: '/'
  routeAfterSignUp: '/'
  routeAfterLogout: '/'
  forceLogin: false
  exceptRoutes: ['about', 'home', 'changelog']
)
