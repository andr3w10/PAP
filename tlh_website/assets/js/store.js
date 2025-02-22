/* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< STORE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */

window.onload = function(){
    start_page();
}


/*=============== SHOW MENU ===============*/
const navMenu = document.getElementById('nav-menu'),
      navToggle = document.getElementById('nav-toggle'),
      navClose = document.getElementById('nav-close')

/*===== MENU SHOW =====*/
/* Validate if constant exists */
if(navToggle){
    navToggle.addEventListener('click', () =>{
        navMenu.classList.add('show-menu')
    })
}

/*===== MENU HIDDEN =====*/
/* Validate if constant exists */
if(navClose){
    navClose.addEventListener('click', () =>{
        navMenu.classList.remove('show-menu')
    })
}

/*=============== REMOVE MENU MOBILE ===============*/
const navLink = document.querySelectorAll('.nav_link')

function linkAction(){
    const navMenu = document.getElementById('nav-menu')
    // When click on each nav_link, remove the show-menu class
    navMenu.classList.remove('show-menu')
}
navLink.forEach(n => n.addEventListener('click', linkAction))

/*=============== CHANGE BACKGROUND HEADER ===============*/
function scrollHeader(){
    const header = document.getElementById('header')
    // When the scroll is greater than 50 viewport height, add the scroll-header class to the header tag
    if(this.scrollY >= 50) header.classList.add('scroll-header'); else header.classList.remove('scroll-header')
}
window.addEventListener('scroll', scrollHeader)

/*=============== NEW ARRIVALS SWIPER ===============*/
let newSwiper = new Swiper(".new-swiper", {
    centeredSlides: true,
    slidesPerView: "auto",
    loop: 'true',
    spaceBetween: 16,
});


/*=============== SHOW SCROLL UP ===============*/ 
function scrollUp(){
    const scrollUp = document.getElementById('scroll-up');
    // When the scroll is higher than 460 viewport height, add the show-scroll class to the a tag with the scroll-top class
    if(this.scrollY >= 460) scrollUp.classList.add('show-scroll'); else scrollUp.classList.remove('show-scroll')
}
window.addEventListener('scroll', scrollUp)


/*=============== SHOW CHECKOUT ===============*/
function show_checkout(id){
    document.getElementById("selected_item_id").setAttribute('value', id);

    let form = document.getElementById("hidden_form");
    form.submit();

    /*checkoutContainer = document.getElementById('checkout-container')
    checkoutContainer.classList.add('show-checkout')*/
}

/*=============== CLOSE CHECKOUT ===============*/
const closeBtn = document.querySelectorAll('.close-checkout')

function closecheckout(){
    const checkoutContainer = document.getElementById('checkout-container')
    checkoutContainer.classList.remove('show-checkout')

    window.location = removeParams('selected_item_id');
}
closeBtn.forEach(c => c.addEventListener('click', closecheckout))


/*=============== CLOSE FILTERS ===============*/
const closefBtn = document.querySelectorAll('.close-filters')

function closefilters(){
    const filtersContainer = document.getElementById('filters-container')
    filtersContainer.classList.remove('show-checkout')

    body = document.getElementsByTagName('body')[0];
    body.classList.remove('block-scroll');
}
closefBtn.forEach(c => c.addEventListener('click', closefilters))




function removeParams(sParam)
{
            var url = window.location.href.split('?')[0]+'?';
            var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('&'),
                sParameterName,
                i;
         
            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');
                if (sParameterName[0] != sParam) {
                    url = url + sParameterName[0] + '=' + sParameterName[1] + '&'
                }
            }
            return url.substring(0,url.length-1);
}


/*=============== START PAGE ===============*/
function start_page(){
    var field = 'selected_item_id';
    var url = window.location.href;
    if(url.indexOf('?' + field + '=') != -1){
        checkoutContainer = document.getElementById('checkout-container');
        checkoutContainer.classList.add('show-checkout');

        body = document.getElementsByTagName('body')[0];
        body.classList.add('block-scroll');
    }

    apply_filters_menu();
}


/*=============== SELECT QUANTITY ===============*/
var numbers = document.getElementById('quantity_box');
for(i=1; i<=20; i++){
    var span = document.createElement('span');
    span.id = "quantity_num";
    span.textContent = i;
    if(i==1){
        span.style.display = 'initial';
        document.getElementById("checkout_item_quantity").setAttribute('value', i);
    }else{
        span.style.display = 'none';
    }
    numbers.appendChild(span);
}
var num = numbers.getElementsByTagName('span');
var index = 0;

function nextNum(){
    num[index].style.display = 'none';
    index = (index + 1) % num.length;
    num[index].style.display = 'initial';
    document.getElementById("checkout_item_quantity").setAttribute('value', index + 1);
}

function prevNum(){
    num[index].style.display = 'none';
    index = (index - 1 + num.length) % num.length;
    num[index].style.display = 'initial';
    document.getElementById("checkout_item_quantity").setAttribute('value', index + 1);
}




/*=============== FINALIZE ===============*/
function buy_pressed(){
    let form = document.getElementById("checkout_form");
    form.submit();
}


/*=============== FILTERS ===============*/

function filtersMenu(){
  window.location="store.php?filters=";
}

function apply_filters_menu(){
  
    var field = 'filters';
    var url = window.location.href;
    var default_url = "http://localhost/tlh_website/html/store.php?filters=";

    var temp = "";

    for(var i=0; i < url.length; i++){
      temp += url[i];
      if(temp == default_url){
        temp="";
      }
    }
    

    var types = [];
    var type_num = -1;
    var price = "";
    var op = -1;

    var temp2 = "";

    for(var i=0; i < temp.length; i++){
      temp2 += temp[i];

      if(temp[i] == "%"){
        temp2 = "";
        op = -1;
      }


      if(op == 0){
        //get the price in url
        price += temp[i];
      }else if(op == 1){
        //get the types in url
        if(temp[i] == "+"){
          type_num++;
          types[type_num] = "";
        }else{
          types[type_num] += temp[i];
        }
      }


      if(temp2 == "price="){
        temp2="";
        op = 0;
      }

      if(temp2 == "types="){
        temp2="";
        op = 1;
      }
    }

    //alert(price);
    //for(var j=0; j < types.length; j++){
    //  alert(types[j]);
    //}
    

    if(url.indexOf('?' + field + '=') != -1){  
        search_bar = document.getElementById("search_bar");
        search_bar.classList.remove('show_main');
        search_bar.classList.add('hide_main');

        main1 = document.getElementById('filters_main');
        main1.classList.add('show_main');
        main1.classList.remove('hide_main');

        main2 = document.getElementById('normal_main');
        main2.classList.remove('show_main');
        main2.classList.add('hide_main');

        body = document.getElementsByTagName('body')[0];
        body.classList.add('block-scroll');


        if(temp != ""){
          closefilters();
        }
    }else{     
        search_bar = document.getElementById("search_bar");
        search_bar.classList.add('show_main');
        search_bar.classList.remove('hide_main');
      
        main1 = document.getElementById('normal_main');
        main1.classList.add('show_main');
        main1.classList.remove('hide_main');

        main2 = document.getElementById('filters_main');
        main2.classList.remove('show_main');
        main2.classList.add('hide_main');

        body = document.getElementsByTagName('body')[0];
        body.classList.remove('block-scroll');
    }
}




/* price slider */
var MAX_DRAG = 500

var xmlns = "http://www.w3.org/2000/svg",
  select = function(s) {
    return document.querySelector(s);
  },
  selectAll = function(s) {
    return document.querySelectorAll(s);
  },
  dragger = select('#dragger'),
  dragVal,
  maxDrag = 300


TweenMax.set('svg', {
  visibility: 'visible'
})

TweenMax.set('#upText', {
  alpha: 0,
  transformOrigin: '50% 50%'
})

TweenLite.defaultEase = Elastic.easeOut.config(0.4, 0.1);

var tl = new TimelineMax({
  paused: true
});
tl.addLabel("blobUp")
  .to('#display1', 1, {
    attr: {
      cy: '-=40',
      r: 30
    }
  })
  .to('#dragger', 1, {
    attr: {
      //cy:'-=2',
      r: 8
    }
  }, '-=1')
  .set('#dragger', {
    strokeWidth: 4
  }, '-=1')
  .to('.downText', 1, {
    //alpha:0,
    alpha: 0,
    transformOrigin: '50% 50%'
  }, '-=1')
  .to('.upText', 1, {
    //alpha:1,
    alpha: 1,
    transformOrigin: '50% 50%'
  }, '-=1')
  .addPause()
  .addLabel("blobDown")
  .to('#display1', 1, {
    attr: {
      cy: 299.5,
      r: 0
    },
    ease: Expo.easeOut
  })
  .to('#dragger', 1, {
    attr: {
      //cy:'-=35',
      r: 15
    }
  }, '-=1')
  .set('#dragger', {
    strokeWidth: 0
  }, '-=1')
  .to('.downText', 1, {
    alpha: 1,
    ease: Power4.easeOut
  }, '-=1')
  .to('.upText', 0.2, {
    alpha: 0,
    ease: Power4.easeOut,
    attr: {
      y: '+=45'
    }
  }, '-=1')

Draggable.create(dragger, {
  type: 'x',
  cursor: 'grab',
  throwProps: true,
  bounds: {
    minX: 0,
    maxX: maxDrag
  },
  onPress: function() {
    tl.play('blobUp')
  },
  onRelease: function() {
    tl.play('blobDown')
  },
  onDrag: dragUpdate,
  onThrowUpdate: dragUpdate
})

function dragUpdate() {
  dragVal = Math.round((this.target._gsTransform.x / maxDrag) * MAX_DRAG);
  select('.downText').textContent = select('.upText').textContent = dragVal;
  TweenMax.to('#display1', 1.3, {
    x: this.target._gsTransform.x
  })
  var price = document.getElementById("max_price");
  price.setAttribute('value', dragVal);

  TweenMax.staggerTo(['.upText', '.downText'], 1, {
    // x:this.target._gsTransform.x,
    cycle: {
      attr: [{
        x: this.target._gsTransform.x + 146
      }]
    },
    ease: Elastic.easeOut.config(1, 0.4)
  }, '0.02')
}

TweenMax.to(dragger, 1, {
  x: 150,
  onUpdate: dragUpdate,
  ease: Power1.easeInOut
})



/* apply */
function apply_filters(){
  var query = "store.php?filters=";

  var price = document.getElementById("max_price").getAttribute('value');
  
  query += "%price=" + price;

  query += "%" + "types=";

  if(document.getElementById('checkbox_items').checked){
    query += "+" + "item";
  }

  if(document.getElementById('checkbox_pets').checked){
    query += "+" + "pet";
  }
  
  if(document.getElementById('checkbox_skins').checked){
    query += "+" + "skin";
  }

  if(document.getElementById('checkbox_decoration').checked){
    query += "+" + "decoration";
  }

  window.location = query;
}