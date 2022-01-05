import cache


def cache_data_result(key_prefix, timeout=1200):
    def func_decorator(function):
        def wrapped(*args, **kwargs):
            if args[0] and '__dict__' in dir(args[0]):
                key_args = str(args[0].__class__)
                key_args += '_'.join([f'{str(key)}_{str(value)}' for key, value in args[0].__dict__.items()])
                key_args += '_'.join([str(args[idx]) for idx in range(1, len(args))])
            else:
                key_args = '_'.join([str(arg) for arg in args])
            key_kwargs = '_'.join([f'{str(key)}_{str(value)}' for key, value in kwargs.items()])
            key = f'{key_prefix}_{function.__name__}_{key_args}' + (f'_{key_kwargs}' if key_kwargs else '')
            if key in cache:
                return cache.get(key)
            else:
                result = function(*args, **kwargs)
                cache.set(key, result, timeout=timeout)
                return result
        return wrapped
    return func_decorator