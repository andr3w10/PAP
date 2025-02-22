/* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LOGIN >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */


/*===== LOGIN SHOW and HIDDEN =====*/
const signUp = document.getElementById('sign-up'),
    signIn = document.getElementById('sign-in'),
    loginIn = document.getElementById('login-in'),
    loginUp = document.getElementById('login-up')


signUp.addEventListener('click', ()=>{
    // Remove classes first if they exist
    loginIn.classList.remove('block')
    loginUp.classList.remove('none')

    // Add classes
    loginIn.classList.toggle('none')
    loginUp.classList.toggle('block')
})

signIn.addEventListener('click', ()=>{
    // Remove classes first if they exist
    loginIn.classList.remove('none')
    loginUp.classList.remove('block')

    // Add classes
    loginIn.classList.toggle('block')
    loginUp.classList.toggle('none')
})


/*=============== SHOW / HIDDEN INPUT LOGIN ===============*/
const showHiddenInputIn = (inputOverlayIn, inputPassIn, inputIconIn) =>{
    const overlay = document.getElementById(inputOverlayIn),
          input = document.getElementById(inputPassIn),
          iconEye = document.getElementById(inputIconIn)
          
    iconEye.addEventListener('click', () =>{
        // Change password to text
        if(input.type === 'password'){
            // Switch to text
            input.type = 'text'

            // Change icon
            iconEye.classList.add('bx-show')
        }else{
            // Change to password
            input.type = 'password'

            // Remove icon
            iconEye.classList.remove('bx-show')
        }

        // Toggle the overlay
        overlay.classList.toggle('overlay-content')
    })
}

showHiddenInputIn('input-overlay-in','input-pass-in','input-icon-in')


/*=============== SHOW / HIDDEN INPUT SIGNUP ===============*/
const showHiddenInputUp = (inputOverlayUp, inputPassUp, inputIconUp) =>{
    const overlay = document.getElementById(inputOverlayUp),
          input = document.getElementById(inputPassUp),
          iconEye = document.getElementById(inputIconUp)
          
    iconEye.addEventListener('click', () =>{
        // Change password to text
        if(input.type === 'password'){
            // Switch to text
            input.type = 'text'

            // Change icon
            iconEye.classList.add('bx-show')
        }else{
            // Change to password
            input.type = 'password'

            // Remove icon
            iconEye.classList.remove('bx-show')
        }

        // Toggle the overlay
        overlay.classList.toggle('overlay-content')
    })
}

showHiddenInputUp('input-overlay-up','input-pass-up','input-icon-up')