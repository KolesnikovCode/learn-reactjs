<%@ tag pageEncoding="UTF-8" %>
<%@ include file="../../../baseAttr.tag" %>

<%@ attribute name="cssClass" required="false" rtexprvalue="true" %>
<%@ attribute name="name" required="false" rtexprvalue="true" %>
<%@ attribute name="id" required="false" rtexprvalue="true" %>

<pre class="prettyprint">
    <code class="language-javascript">
    class Welcome extends React.Component {
      render() {
        return &lt;h1&gt;Hello, {this.props.name}&lt;/h1&gt;;
      }
    }
    </code>
</pre>