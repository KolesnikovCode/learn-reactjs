<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lt" tagdir="/WEB-INF/tags/layout" %>
<%@taglib prefix="wg" tagdir="/WEB-INF/tags/widget" %>
<%@taglib prefix="ce" tagdir="/WEB-INF/tags/application/core/refs-and-the-dom" %>
<%@taglib prefix="app" tagdir="/WEB-INF/tags/application" %>

<c:url var="refForwardingUrl" value="forwarding-refs"/>
<c:url var="domRefForwardingAlternativesBefore_16_3Url" value="https://gist.github.com/gaearon/1a018a023347fe1c2476073330cc5509"/>

<a name="pageStart"></a>
<lt:layout cssClass="black-line"/>
<lt:layout cssClass="page hello-world-example-page">
  <h1>3.3 Ссылки ref и DOM</h1>
  
  <wg:p>
    Ссылки предоставляют способ доступа к узлам DOM или элементам React,
    созданным в методе отрисовки(render).
  </wg:p>

  <wg:p>В типичном потоке данных React, свойства <code>props</code> – это единственный способ
    взаимодействия родительского компонента с его потомком. Чтобы модифицировать потомка,
    вы перерисовываете его с новыми свойствами. Тем не менее, есть несколько случаев,
    когда вам необходимо модифицировать потомок вне обычного потока данных. Потомок,
    подлежащий модификации, может быть экземпляром React-компонента или являться DOM-элементом.
    Для обоих этих случаев, React предоставляет «запасной выход».</wg:p>

  <br/>
  <h2>3.3.1 Когда использовать ссылки ref</h2>

  <wg:p>Существует несколько оправданных случаев использования ссылок <code>ref</code>:</wg:p>

  <wg:p>
    <ul>
      <li>Управление фокусом, выделением текста или воспроизведением мультимедиа</li>
      <li>Переключение необходимой анимации</li>
      <li>Интеграция со сторонними DOM библиотеками</li>
    </ul>
  </wg:p>

  <wg:p><b>Избегайте использования ссылок для всего, что может быть реализовано декларативным путем!</b></wg:p>

  <wg:p>К примеру, вместо публичных методов <code>open()</code> и <code>close()</code> на компоненте <code>Dialog</code>,
    передавайте в него свойство <code>isOpen</code>.</wg:p>

  <br/>
  <h2>3.3.2 Не злоупотребляйте ссылками ref</h2>

  <wg:p>По началу вы можете быть склонны использовать ссылки ref для того, чтобы
    «достигнуть результата» в вашем приложении. Если это так, то возьмите немного
    времени и  подумайте более критично о том, кто должен владеть состоянием в иерархии компонентов.
    Часто, становится понятно, что правильное место, где должно находиться состояние,
    это более высокий уровень в иерархии. Смотрите главу «Передача состояния вверх по иерархии» в
    качестве примера.</wg:p>
  
  <app:alert type="warning" title="Внимание!">
    Приведенные ниже примеры были обновлены, для возможности использования API <code>React.createRef()</code>,
    введенный в <b>релизе 16.3</b>. Если вы используете более раннюю версию React, мы
    рекомендуем использовать API обратного вызова.
  </app:alert>
  
  <a name="createRefAPI"></a>
  <br/>
  <h2>3.3.3 Создание ссылок</h2>
  <wg:p>
    Ссылки создаются с использованием метода <code>React.createRef()</code> и присоединяются к
    элементам React с помощью атрибута <code>ref</code>. Как правило, они назначаются свойствам экземпляра
    компонента, в то время как компонент сконструирован таким образом, чтобы ссылки были
    доступны из любого места этого компонента.
  </wg:p>
  
  <ce:code-example-1/>
  
  <br/>
  <h2>3.3.4 Доступ к ссылкам</h2>
  
  <wg:p>
    Когда <code>ref</code> передается элементу в методе <code>render()</code>, ссылка на узел становится
    доступной в атрибуте <code>current</code>.
  </wg:p>
  <ce:code-example-2/>
  
  <wg:p>Значение <code>ref</code> отличается в зависимости от типа узла:</wg:p>
  
  <wg:p>
    <ul>
      <li>
        Когда атрибут <code>ref</code> используется на HTML-элементе, объект <code>ref</code>, созданный
        в конструкторе с помощью <code>React.createRef()</code>, в качестве значения своего свойства
        <code>current</code> получает нативный DOM элемент.
      </li>
      <li>
        Когда атрибут <code>ref</code> используется на пользовательском компоненте-классе, объект <code>ref</code>
        в качестве значения своего свойства <code>current</code> получает монтированный экземпляр компонента.
      </li>
      <li><b>Вы не можете использовать атрибут</b> <code>ref</code> <b>для компонентов-функций</b>,
        так как они не имеют экземпляров.</li>
    </ul>
  </wg:p>
  
  <wg:p>Приведенные ниже примеры демонстрируют эти различия.</wg:p>

  <br/>
  <h3>3.3.4.1 Добавление ссылки ref на DOM-элемент</h3>
  
  <wg:p>
    Данный код использует <code>ref</code> для хранения ссылки на узел DOM:
  </wg:p>
  
  <ce:code-example-3/>
  
  <wg:p>
    React присвоит свойству current элемент DOM, когда компонент будет монтирован,
    и значение <code>null</code>, когда компонент будет демонтирован. Обновления <code>ref</code> происходят перед
    срабатыванием методов ЖЦ <code>componentDidMount</code> или <code>componentDidUpdate</code>.
  </wg:p>
  
  <a name="addingRefToComponentClass"></a>
  <br/>
  <h3>3.3.4.2 Добавление ссылки ref на компонент-класс</h3>

  <wg:p>
    Если бы мы захотели обернуть компонент <code>CustomTextInput</code> выше, чтобы имитировать нажание по нему
    сразу после монтирования, мы могли бы использовать атрибут <code>ref</code> для доступа к этому компоненту и
    вручную вызвать его метод <code>focusTextInput()</code>:
  </wg:p>
  
  <ce:code-example-4/>
  
  <wg:p>
    Обратите внимание, что это работает только в том случае,
    если <code>CustomTextInput</code> объявлен как класс:
  </wg:p>

  <ce:code-example-5/>

  <br/>
  <h3>3.3.4.3 Ссылки ref и функциональные компоненты</h3>

  <wg:p><b>Нельзя использовать атрибут <code>ref</code> на
    компонентах-функциях, так как они не имеют экземпляров:</b></wg:p>

  <ce:code-example-6/>

  <wg:p>Вы должны преобразовать компонент в класс, если хотите ссылаться на него. Точно так же вы делаете,
    когда вам необходимо наделить компонент методами жизненного цикла и состоянием.</wg:p>

  <wg:p>Вы, тем не менее, <b>можете использовать атрибут</b> <code>ref</code> <b>внутри функционального компонента</b>,
    так как вы ссылаетесь на DOM-элемент или класс компонента:</wg:p>

  <ce:code-example-7/>

  <br/>
  <h2>3.3.5 Предоставление ссылок на DOM узлы родительским компонентам</h2>

  <wg:p>В редких случаях, вы можете захотеть получать доступ к DOM-элементам потомков из родительского
    компонента. Как правило, это не рекомендуется, так как разрушает инкапсуляцию компонента.
    Но изредка это может быть полезным для переключения фокуса, определения размера или позиции DOM-элемента
    потомка.</wg:p>

  <wg:p>В то время как вы имеете возможность <wg:link href="#addingRefToComponentClass">добавлять ссылку на
    компонент потомка,</wg:link> это не
    является идеальным решением, так как в коллбэке атрибута <code>ref</code> вы можете получить только
    экземпляр компонента, а не DOM-узел. Вдобавок, это не будет работать с функциональными компонентами.</wg:p>
  
  <wg:p>
    Если вы используете React 16.3 и выше, для таких случаев мы рекомендуем использовать
    <wg:link href="${refForwardingUrl}">передачу ссылок.</wg:link> <b>Передача ссылок дает компонентам свободу выбора, в предоставлении
    любых ссылок своих из потомков.</b> Вы можете найти подробный пример того, как предоставить
    дочерний DOM узел родительскому компоненту в документации по передаче ссылок.
  </wg:p>
  
  <wg:p>
    Если вы используете React 16.2 и ниже, или если вам нужна большая гибкость, чем
    предоставленная передачей ссылок, вы можете использовать
    <wg:link href="${domRefForwardingAlternativesBefore_16_3Url}">данный альтернативный подход</wg:link> и явно
    передать ссылку как свойство с другим именем.
  </wg:p>

  <wg:p>
    В целом, когда это возможно, рекомендуется не предоставлять доступ к узлам DOM,
    но в некоторых ситуациях это может оказаться "безопасным выходом". Обратите внимание,
    что для данного подхода вам необходимо добавить код к дочернему компоненту.
    Если у вас нет абсолютно никакого контроля над реализацией дочернего компонента,
    ваш последний вариант - использовать <code>findDOMNode()</code>, но это не рекомендуется.
  </wg:p>
  
  <a name="callbackPattern"></a>
  <br/>
  <h2>3.3.6 Ref-коллбэки</h2>
  
  <wg:p>
    React также поддерживает и другой способ установки ссылок ref, называемый «callback refs»
    или «ref-коллбэки», который дает более гибкий контроль в моменты, когда ссылки
    установлены и не установлены.
  </wg:p>
  
  <wg:p>
    Вместо передачи объекта <code>ref</code>, созданного <code>createRef()</code>, вы передаете функцию.
    Функция получает экземпляр компонента React или HTML DOM элемент в качестве своего аргумента.
    Его можно сохранить и затем получить в любом другом месте компонента.
  </wg:p>
  
  <wg:p>
    В приведенном ниже примере реализован общий паттерн: использование обратного
    вызова в атрибуте <code>ref</code> для сохранения ссылки на узел DOM в свойстве экземпляра.
  </wg:p>
  
  <ce:code-example-8/>
  
  <wg:p>
    Когда компонент будет монтирован, React вызовет коллбэк атрибута <code>ref</code>,
    передав ему в качестве аргумента DOM элемент. При демонтировании коллбэк будет вызван с
    аргументом равным <code>null</code>. <code>ref</code>-коллбэки вызываются перед методами жизненного
    цикла <code>componentDidMount</code> и <code>componentDidUpdate</code>.
  </wg:p>
  
  <wg:p>
    Вы можете передавать <code>ref</code>-колбэки между компонентами также, как и объекты,
    созданные с помощью <code>React.createRef()</code>.
  </wg:p>
  
  <ce:code-example-9/>
  
  <wg:p>
    В приведенном выше примере <code>Parent</code> передает свой <code>ref</code>-коллбэк как
    свойство <code>inputRef</code> в <code>CustomTextInput</code>, а <code>CustomTextInput</code> передает эту же функцию как
    специальный атрибут <code>ref</code> в <code>&lt;input&gt;</code>. В результате <code>this.inputElement</code> в <code>Parent</code>
    будет установлен на DOM узел, соответствующий элементу <code>&lt;input&gt;</code> в <code>CustomTextInput</code>.
  </wg:p>

  <br/>
  <h2>3.3.7 Старый API: строковые ссылки ref</h2>

  <wg:p>Если вы использовали React ранее, вы могли быть знакомы со старым API,
    где <code>ref</code> атрибут мог быть строкой, вроде "<code>textInput</code>", и DOM-узел был доступен
    как <code>this.refs.textInput</code>. Мы рекомендуем избегать этого, потому что строковые
    ссылки имеют некоторые проблемы, являются устаревшими и <b>скорее всего будут
    удалены в следующих релизах.</b></wg:p>
    
  <app:alert type="warning" title="Внимание!">
    Если вы до сих пор используете <code>this.refs.textInput</code>,
    чтобы получать доступ к ссылкам, мы рекомендуем вместо этого использовать паттерн
    <wg:link href="#callbackPattern"><b>callback</b></wg:link> или <wg:link href="#createRefAPI">createRef API</wg:link>.
  </app:alert>

  <br/>
  <h2>3.3.8 Предостережения</h2>

  <wg:p>Если коллбэк атрибута <code>ref</code> определен как встроенная функция,
    <b>она будет вызываться дважды во время перерисовок</b>: сперва с <code>null</code>,
    а затем снова с DOM-элементом. Это происходит потому, что во время каждой фазы
    отрисовки создается новый экземпляр функции, поэтому React необходимо очистить
    старый <code>ref</code> и установить новый. Вы можете
    этого избежать, определяя коллбэк как связанный метод в классе, но
    обратите внимание, что в большинстве случаев это не имеет большого значения.</wg:p>
</lt:layout>

<c:url var="prevPageUrl" value="typechecking-with-prop-types"/>
<c:url var="nextPageUrl" value="uncontrolled-components"/>
<app:page-navigate prevPageUrl="${prevPageUrl}"
                   pageStartAncor="pageStart"
                   nextPageUrl="${nextPageUrl}"/>