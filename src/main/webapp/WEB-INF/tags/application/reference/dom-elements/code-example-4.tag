<%@ tag pageEncoding="UTF-8" %>
<%@ include file="../../../baseAttr.tag" %>
<%@taglib prefix="cd" tagdir="/WEB-INF/tags/application/code" %>

<%@ attribute name="cssClass" required="false" rtexprvalue="true" %>
<%@ attribute name="name" required="false" rtexprvalue="true" %>
<%@ attribute name="id" required="false" rtexprvalue="true" %>
<%@ attribute name="codePenUrl" required="false" rtexprvalue="true"%>

<cd:code-example-decorator codePenUrl="${codePenUrl}">
  <pre class="prettyprint">
    <code class="language-javascript">
  accept acceptCharset accessKey action allowFullScreen allowTransparency alt
  async autoComplete autoFocus autoPlay capture cellPadding cellSpacing challenge
  charSet checked cite classID className colSpan cols content contentEditable
  contextMenu controls coords crossOrigin data dateTime default defer dir
  disabled download draggable encType form formAction formEncType formMethod
  formNoValidate formTarget frameBorder headers height hidden high href hrefLang
  htmlFor httpEquiv icon id inputMode integrity is keyParams keyType kind label
  lang list loop low manifest marginHeight marginWidth max maxLength media
  mediaGroup method min minLength multiple muted name noValidate nonce open
  optimum pattern placeholder poster preload profile radioGroup readOnly rel
  required reversed role rowSpan rows sandbox scope scoped scrolling seamless
  selected shape size sizes span spellCheck src srcDoc srcLang srcSet start step
  style summary tabIndex target title type useMap value width wmode wrap</code>
  </pre>
</cd:code-example-decorator>