<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lt" tagdir="/WEB-INF/tags/layout" %>
<%@taglib prefix="wg" tagdir="/WEB-INF/tags/widget" %>
<%@taglib prefix="ce" tagdir="/WEB-INF/tags/application/core/reconciliation" %>
<%@taglib prefix="app" tagdir="/WEB-INF/tags/application" %>

<c:url var="granularDomUpdatesUrl" value="/resources/imges/pages/basics/render-elements/granular-dom-updates.gif"/>

<lt:layout cssClass="page hello-world-example-page">
  <wg:head size="3"><b>3.8 Согласование</b></wg:head>

  <wg:p>React предоставляет декларативный API, так что вам не нужно беспокоиться о том, какие именно
    изменения происходят при каждом обновлении. Это значительно упрощает написание приложений, но
    может быть неочевидно, как это реализовано в React. В этой статье объясняются подходы, которые
    реализовали разработчики в алгоритме React, чтобы обновления компонентов были предсказуемыми,
    будучи достаточно быстрыми для высокопроизводительных приложений.</wg:p>

  <br/>
  <wg:head size="3"><b>3.8.1 Мотивация</b></wg:head>

  <wg:p>Когда вы используете React, в определенный момент времени вы можете думать о
    функции <code>render ()</code> как о создателе дерева элементов React. При следующем обновлении
    состояния или свойств функция <code>render ()</code> вернет другое дерево элементов React. После
    этого React необходимо выяснить, как эффективно обновить пользовательский интерфейс,
    чтобы соответствовать последнему дереву.</wg:p>

  <wg:p>Существуют некоторые общие решения этой алгоритмической задачи генерации
    минимального количества операций для преобразования одного дерева в другое.
    Однако современные алгоритмы имеют сложность порядка <b>O(n3)</b>, где <b>n</b>
    - количество элементов в дереве.</wg:p>

  <wg:p>Если использовать это в React, то для отображения 1000 элементов
    потребуется порядка одного миллиарда сравнений. Это слишком дорого. Вместо этого React
    реализует эвристический алгоритм O (n), основанный на двух предположениях:</wg:p>

  <wg:p>
    <ul>
      <li>Два элемента разных типов будут создавать разные деревья.</li>
      <li>Разработчик может указать, какие дочерние элементы могут быть
        стабильными между разными отрисовками с помощью свойства <code>key</code>.</li>
    </ul>
  </wg:p>

  <wg:p>На практике эти предположения применимы почти для всех практических случаев.</wg:p>

  <br/>
  <wg:head size="3"><b>3.8.2 Алгоритм сравнения</b></wg:head>

  <wg:p>При сравнении двух деревьев, React сначала сравнивает два корневых элемента.
    Поведение различно в зависимости от типов корневых элементов.</wg:p>

  <br/>
  <wg:head size="4"><b>3.8.2.1 Элементы различных типов</b></wg:head>

  <wg:p>Всякий раз, когда корневые элементы имеют разные типы, React будет
    уничтожать старое дерево и строить новое с нуля. Переходы
    от <code>&lt;a&gt;</code> к <code>&lt;img&gt;</code>, или от
    <code>&lt;Article&gt;</code> к <code>&lt;Comment&gt;</code>,
    или от <code>&lt;Button&gt;</code> к <code>&lt;div&gt;</code> - любой из них
    приведет к полной перестройке дерева.</wg:p>

  <wg:p>При уничтожении дерева старые DOM-узлы удаляются. React вызывает
    <code>componentWillUnmount()</code> для экземпляров компонентов. При создании нового
    дерева новые DOM-узлы вставляются в DOM. React вызывает  <code>componentWillMount()</code>,
    а затем <code>componentDidMount()</code> для экземпляров компонентов. Любое состояние,
    связанное со старым деревом, теряется.</wg:p>

  <wg:p>Любые компоненты ниже корня также будут демонтированы и уничтожены. Например, при сравнении:</wg:p>

  <ce:code-example-1/>

  <wg:p>React уничтожит старый пользовательский и перемонтирует новый.</wg:p>

  <br/>
  <wg:head size="4"><b>3.8.2.2 DOM-элементы одинакового типа</b></wg:head>

  <wg:p>При сравнении двух React DOM элементов того же типа React рассматривает атрибуты обоих,
    сохраняет один и тот же базовый узел DOM и обновляет только измененные атрибуты. Например:</wg:p>

  <ce:code-example-2/>

  <wg:p>Сравнивая эти два элемента, React обнаруживает, что необходимо изменить только имя
    класса на базовом узле DOM.</wg:p>

  <wg:p>При обновлении стиля <code>style</code> React обнаруживает, что необходимо обновить только измененное
    свойство <code>color</code>. Например:</wg:p>

  <ce:code-example-3/>

  <wg:p>При преобразовании React изменит только свойство <code>color</code>, но не <code>fontWeight</code>.</wg:p>

  <wg:p>После обработки DOM узла React всё рекурсивно повторяет на дочерних элементах.</wg:p>

  <br/>
  <wg:head size="4"><b><a class="anchor" name="recursing-on-children">3.8.2.3 Рекурсивный обход дочерних элементов</a></b></wg:head>

  <wg:p>По умолчанию при рекурсивном обходе дочерних DOM узлов React просто выполняет итерацию
    по обоим спискам потомков одновременно и формирует изменение всякий раз, когда обнаружено отличие.</wg:p>

  <wg:p>Например, при добавлении элемента в конец списка потомков преобразование между этими
    двумя деревьями работает хорошо:</wg:p>

  <ce:code-example-4/>

  <wg:p>React соотнесёт два дерева &lt;li&gt;Один&lt;/li&gt;, два дерева &lt;li&gt;Два&lt;/li&gt;, а
    затем вставит дерево &lt;li&gt;Три&lt;/li&gt;.</wg:p>

  <wg:p>Если вы реализуете это в таком виде, вставка элемента в начало списка будет иметь худшую производительность.
    Например, преобразование между этими двумя деревьями работает неэффективно:</wg:p>

  <ce:code-example-5/>

  <wg:p>React будет изменять каждый потомок вместо того, чтобы понять, что он
    может оставить поддеревья &lt;li&gt;Один&lt;/li&gt; и &lt;li&gt;Два&lt;/li&gt; нетронутыми. Такая
    неэффективность является проблемой, особенно в больших приложениях.</wg:p>

  <br/>
  <wg:head size="4"><b>3.8.2.4 Ключи</b></wg:head>

  <wg:p>Чтобы решить эту проблему, React поддерживает атрибут <code>key</code>. Когда у
    потомков есть ключи, React использует ключ для установления соответствия
    потомков в исходном дереве с дочерними элементами в последующем дереве. </wg:p>

  <wg:p>Например, добавление ключа к нашему неэффективному примеру выше может
    сделать преобразование дерева эффективным:</wg:p>

  <ce:code-example-6/>

  <wg:p>Теперь React знает, что элемент с ключом <code>“0”</code> является новым, а элементы с
    ключами <code>“1”</code> и <code>“2”</code> только что переместились.</wg:p>

  <wg:p>На практике найти ключ обычно не сложно. Элемент, который вы собираетесь отображать,
    может уже иметь уникальный идентификатор, поэтому ключ может быть получен просто из ваших данных:</wg:p>

  <ce:code-example-7/>

  <wg:p>Если это не так, вы можете добавить новое свойство идентификатора к своей модели
    или хеш части содержимого, чтобы сгенерировать ключ. Ключ должен быть уникальным среди
    своих соседей, а не глобально уникальным.</wg:p>

  <wg:p>В крайнем случае вы можете передать индекс элемента в массиве в качестве ключа.
    Это будет хорошо работать, если элементы никогда не переупорядочиваются, но
    переупорядочивание будет работать медленно.</wg:p>

  <br/>
  <wg:head size="4"><b>3.8.2.5 Компромисы</b></wg:head>

  <wg:p>Важно помнить, что алгоритм согласования является деталью реализации.
    React может перерисовывать все приложение в ответ на каждое действие.
    Конечный результат будет таким же. Разработчики регулярно совершенствуют эвристики,
    чтобы сделать общие случаи использования быстрее по производительности.</wg:p>

  <wg:p>В текущей реализации если вы можете сказать, что поддерево перемещено относительно
    своих соседей, но не можете сказать, что оно переместилось где-либо еще, алгоритм перерисует
    всё это поддерево.</wg:p>

  <wg:p>Поскольку React полагается на эвристики, то если предположения, стоящие за ними, не
    выполняются, производительность будет страдать.</wg:p>

  <wg:p>
    <ul>
      <li>Алгоритм не будет пытаться сопоставить поддеревья разных типов компонентов.
        Если вы видите, что работаете с двумя типами компонентов, имеющих очень похожий вывод,
        вы можете сделать их одним и тем же компонентом. На практике это не вызывает проблем.</li>
      <li>Ключи должны быть стабильными, предсказуемыми и уникальными. Нестабильные ключи
        (например, созданные с <code>Math.random()</code>) приведут к излишнему пересозданию множества
        экземпляров компонентов и узлов DOM, что может привести к ухудшению
        производительности и потере состояния в дочерних компонентах.</li>
    </ul>
  </wg:p>
</lt:layout>