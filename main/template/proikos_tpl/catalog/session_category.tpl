<div class="row">
    <div class="grid-category text-center">
        {% for category in categories %}
        <div class="col-md-4">
            <div class="category-item" style="background-color: {{ category.color }}">
                <h2 class="title"><a href="?action=display_sessions&category={{ category.id }}">{{ category.name }}</a></h2>
            </div>
        </div>
        {% endfor %}
    </div>
</div>