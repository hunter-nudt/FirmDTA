// JavaScript Document

function goSetHeight() {
  if (parent == window) return;
  // no way to obtain id of iframe object doc loaded into? no parentNode or parentElement or ...
  else parent.setIframeHeight('ifrm');
}

