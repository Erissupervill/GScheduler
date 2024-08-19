from flask import Blueprint, redirect, render_template, url_for

routes_bp = Blueprint('routes', __name__)

@routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes.login"))


def page_not_found(error):
    print(error)
    return render_template("page_not_found.html"), 404


# Register blueprints
def register_routes(app):
    from .staff_routes import staff_routes_bp
    from .admin_routes import admin_routes_bp
    from .auth_routes import auth_routes_bp
    from .user_routes import user_routes_bp
    
    app.register_blueprint(routes_bp)
    app.register_blueprint(admin_routes_bp)
    app.register_blueprint(staff_routes_bp)
    app.register_blueprint(auth_routes_bp)
    app.register_blueprint(user_routes_bp)