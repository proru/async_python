class RoleMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        return response

    def process_view(self, request, view_func, *view_args, **view_kargs):
        # how to identice users?
        print("Middleware works!")
        print(dir(request))
        print(dir(request.user))
        print(dir(request.user.username))
        print(request.user.username)
        print(dir(view_func))
