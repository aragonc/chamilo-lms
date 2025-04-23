<script>
    $(function () {
        $('#date').datepicker({
            dateFormat: 'yy-mm-dd'
        });
    });
</script>

<!-- header catalog session -->
<div class="search-session">
    <div class="row">
        {% if catalog_settings.sessions.by_title %}
        <div class="col-md-4">
            <form method="post" action="{{ _p.web_main }}auth/courses.php?action=search_session_title">
                <label>{{ "Name"|get_lang }}</label>
                <div class="input-group">
                    <input type="text" name="keyword" title="{{ 'Name'|get_lang }}" class="form-control"
                           value="{{ keyword }}"/>
                    <span class="input-group-btn">
                            <button class="btn btn-default" type="submit">
                                <em class="fa fa-search"></em> {{ 'Search'|get_lang }}
                            </button>
                        </span>
                </div>
            </form>
        </div>
        {% endif %}

        {% if catalog_settings.sessions.by_date %}
        <div class="col-md-4">
            <form method="post" action="{{ _p.web_main }}auth/courses.php?action=display_sessions">
                <div class="form-group">
                    <label>{{ "ByDate"|get_lang }}</label>
                    <div class="input-group">
                        <input type="date" name="date" id="date" title="{{ 'Date'|get_lang }}"
                               class="form-control" value="{{ search_date }}" readonly>
                        <span class="input-group-btn">
                                <button class="btn btn-default" type="submit">
                                    <em class="fa fa-search"></em> {{ 'Search'|get_lang }}
                                </button>
                            </span>
                    </div>
                </div>
            </form>
        </div>
        {% endif %}

        {% if catalog_settings.sessions.by_tag %}
        <div class="col-md-4">
            <form method="post" action="{{ _p.web_main }}auth/courses.php?action=search_tag">
                <label>{{ "ByTag"|get_lang }}</label>
                <div class="input-group">
                    <input type="text" name="search_tag" title="{{ 'ByTag'|get_lang }}" class="form-control"
                           value="{{ search_tag }}"/>
                    <span class="input-group-btn">
                            <button class="btn btn-default" type="submit">
                                <em class="fa fa-search"></em> {{ 'Search'|get_lang }}
                            </button>
                        </span>
                </div>
            </form>
        </div>
        {% endif %}
    </div>
</div>
<!-- new view session grib -->
<div class="row">
    <div class="grid-courses col-md-12">
        <div class="row">
            <div class="message-extra">
                <strong>Recuerda que:</strong>
                <p>Los proximas fechas de inscripción a los cursos serán en las siguientes fechas:</p>
                <ul>
                    {% for item in nexts %}
                        <li>{{ item }}</li>
                    {% endfor %}
                </ul>
            </div>
            {% for item in sessions %}

            {% if item.session_hide == true %}
            <div class="col-md-4 col-sm-6 col-xs-12">
                <div id="session-{{ item.id }}" class="items items-courses items-sessions {{ item.session_enabled_user }}">
                    <div class="image">
                        {% if item.session_full %}
                            <img class="img-responsive" src="{{ item.image ? _p.web_upload ~ item.image : 'session_default.png'|icon() }}"
                                 alt="{{ item.name }}">
                        {% else %}
                            <a href="{{ _p.web ~ 'session/' ~ item.id ~ '/about/' }}" title="{{ item.name }}">
                                <img class="img-responsive" src="{{ item.image ? _p.web_upload ~ item.image : 'session_default.png'|icon() }}"
                                     alt="{{ item.name }}">
                            </a>
                        {% endif %}
                        {% if item.category != '' %}
                            <span class="category">{{ item.category }}</span>
                            <div class="cribbon"></div>
                        {% endif %}
                        <div class="admin-actions">
                            {% if item.edit_actions != '' %}
                            <a class="btn btn-default btn-sm" href="{{ item.edit_actions }}">
                                <i class="fa fa-pencil" aria-hidden="true"></i>
                            </a>
                            {% endif %}
                            {% if item.is_subscribed %}
                            {{ already_subscribed_label }}
                            {% endif %}
                        </div>
                    </div>
                    <div class="description">

                        <div class="block-title">
                            {% if item.session_full %}
                            <h4 class="title">
                                {{ item.name }}
                            </h4>
                            {% else %}
                                <h4 class="title {{ item.session_enabled_user }}">
                                    <a href="{{ _p.web ~ 'session/' ~ item.id ~ '/about/' }}" title="{{ item.name }}">
                                        {{ item.name }}
                                    </a>
                                </h4>
                            {% endif %}
                        </div>
                        {% if show_tutor and item.coach_id %}
                        <div class="block-author">
                            <div class="author-card">
                                <a href="{{ item.coach_url }}" class="ajax" data-title="{{ item.coach_name }}">
                                    <img src="{{ item.coach_avatar }}" alt="{{ item.coach_name }}">
                                </a>
                                <div class="teachers-details">
                                    <h5>
                                        <a href="{{ item.coach_url }}" class="ajax" data-title="{{ item.coach_name }}">
                                            {{ item.coach_name }}
                                        </a>
                                    </h5>
                                    <p>{{ 'SessionGeneralCoach'|get_lang }}</p>
                                </div>
                            </div>
                        </div>
                        {% endif %}

                        {% if catalog_settings.sessions.show_session_info %}
                        <div class="block-info">
                            <ul class="info list-inline">
                                <li class="course_label_number_courses">
                                    <i class="fa fa-book" aria-hidden="true"></i>
                                    {{ item.nbr_courses ~ ' ' ~ 'Courses'|get_lang }}
                                </li>
                                <li class="course_label_number_users">
                                    <i class="fa fa-user" aria-hidden="true"></i>
                                    {{ item.nbr_users ~ '/' ~ item.maximum_users ~ ' ' ~ 'NbUsers'|get_lang }}
                                </li>
                            </ul>
                        </div>
                        {% endif %}
                        {#
                            {% if catalog_settings.sessions.show_session_date %}
                            <div class="block-date">
                                {{ item.duration ? 'SessionDurationXDaysLeft'|get_lang|format(item.duration) : item.date }}
                            </div>
                            {% endif %}
                        #}
                        <div class="toolbar">
                            {% if item.price %}
                            <div class="item-price">
                                {{ item.price }}
                            </div>
                            {% endif %}
                            {% if _u.logged %}
                            <div class="item-subscribed">
                                <div class="btn-group btn-group-sm" role="group">
                                    {% if not item.sequences is empty %}
                                    <a class="btn btn-default btn-sm" role="button"
                                       title="{{ 'SeeSequences'|get_lang }}" data-toggle="popover"
                                       id="session-{{ item.id }}-sequences">
                                        <i class="fa fa-sitemap" aria-hidden="true"></i>
                                    </a>
                                    {% endif %}
                                    {% if item.session_full %}
                                        <div class="item-close">Inscripciones cerradas por máximo de participantes</div>
                                    {%  else %}
                                        {% if item.is_subscribed == false %}
                                            {{ item.subscribe_button }}
                                        {% endif %}
                                    {% endif %}
                                </div>
                            </div>
                            {% endif %}
                        </div>
                    </div>
                    {% if _u.logged %}
                    <script>
                        $('#session-{{ item.id }}-sequences').popover({
                            placement: 'bottom',
                            html: true,
                            trigger: 'click',
                            content: function () {
                                {% if item.sequences %}
                                var content = '';

                                {% for sequence in item.sequences %}
                                content += '<p class="lead">{{ sequence.name }}</p>';
                                {% if sequence.requirements %}
                                content += '<p><em class="fa fa-sort-amount-desc"></em> {{ 'RequiredSessions'|get_lang }}</p>';
                                content += '<ul>';

                                {% for requirement in sequence.requirements %}
                                content += '<li>';
                                content += '<a href="{{ _p.web ~ 'session/' ~ requirement.id ~ '/about/' }}">{{ requirement.name }}</a>';
                                content += '</li>';
                                {% endfor %}

                                content += '</ul>';
                                {% endif %}

                                {% if sequence.dependencies %}
                                content += '<p><em class="fa fa-sort-amount-desc"></em> {{ 'DependentSessions'|get_lang }}</p>';
                                content += '<ul>';

                                {% for dependency in sequence.dependencies %}
                                content += '<li>';
                                content += '<a href="{{ _p.web ~ 'session/' ~ dependency.id ~ '/about/' }}">{{ dependency.name }}</a>';
                                content += '</li>';
                                {% endfor %}

                                content += '</ul>';
                                {% endif %}

                                {% if item.sequences|length > 1 %}
                                content += '<hr>';
                                {% endif %}
                                {% endfor %}

                                return content;
                                {% else %}
                                return "{{ 'NoDependencies'|get_lang }}";
                                {% endif %}
                            }
                        });
                    </script>
                    {% endif %}
                </div>
            </div>
            {% endif %}
            {% else %}
            <div class="col-xs-12">
                <div class="alert alert-warning">
                    {{ 'NoResults'|get_lang }}
                </div>
            </div>
            {% endfor %}
        </div>
    </div>
</div>

<!-- end view session grib -->
{# catalog_pagination #}
