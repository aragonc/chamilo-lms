<div id="navigation" class="notification-panel">
    {{ help_content }}
    {{ bug_notification }}
</div>
{% block topbar %}
    {% include 'layout/topbar.tpl'|get_template %}
{% endblock %}

{% if header_extra_content is not null %}
    {{ header_extra_content }}
{% endif %}

<div class="container">
    <div class="row">
        <div class="col-xs-12 col-md-4">
            {% if entity_proikos %}
                <div class="logos">
                    <div class="logo_campus">
                        <a href="{{ _p.web }}">
                            <img width="180px" src="{{ _p.web_css_theme }}images/logo.svg">
                        </a>
                    </div>
                    <div class="logo_entity">
                        <img height="78px" src="{{ entity_proikos }}">
                    </div>
                </div>
            {% else %}
                <div class="logos">
                    <div class="logo_campus">
                        <a href="{{ _p.web }}">
                            <img width="180px" src="{{ _p.web_css_theme }}images/logo.svg">
                        </a>
                    </div>
                </div>
            {% endif %}
        </div>
        <div class="col-xs-12 col-md-8">
            {% block menu %}
            {% include 'layout/menu.tpl'|get_template %}
            {% endblock %}
            <div class="accessibility-font">
                {{ accessibility }}
            </div>
        </div>
    </div>
</div>

{% include 'layout/course_navigation.tpl'|get_template %}
