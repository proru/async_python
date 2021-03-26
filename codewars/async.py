import asyncio
import concurrent.futures
import aiohttp
from payment_subsystem.settings import CEPH_BUCKET_NAME
from utils.common_logging import ao_logger
import sys
from django.conf import settings
from abc import ABC, abstractmethod
import jwt
from utils.http_adapter_service import KeycloakSessionAuth, JwtSessionAuth
from billing_information_management.infrastructure_layer.services.ceph_adapter_instance import CephAdapterInstance
from billing_information_management.domain_layer.services.reconciliation_report_artifact import \
    ReconciliationReportArtifactManager
import asyncio
from billing_information_management.infrastructure_layer.services.ceph_adapter import CephAdapter
import concurrent.futures
import logging
import sys
import time


# class ReconciliationReportCephSave:
#     def __init__(self):
#         self.loop = asyncio.new_event_loop()
#
#     # self.loop = asyncio.new_event_loop()
#     #
#     # def run(self, data):
#     #     list_reports = data
#     #     ceph_resource = CephAdapterInstance()
#     #     ceph_resource.set_resource()
#     #     reports_tasks = [self.save_report_ceph(report, ceph_resource) for report in list_reports]
#     #     self.loop.run_until_complete(asyncio.wait(reports_tasks))
#     #     with concurrent.futures.ThreadPoolExecutor() as pool:
#     #         result = await self.loop.run_in_executor(pool, )
#     #         print('custom thread pool', result)
#     async def run_blocking_tasks(self, executor, reports, ceph_resource):
#         log = logging.getLogger('run_blocking_tasks')
#         log.info('starting')
#         log.info('creating executor tasks')
#         # loop = asyncio.get_event_loop()
#         blocking_tasks = [
#             self.loop.run_in_executor(executor, self.save_report_ceph, report, ceph_resource)
#             for report in reports
#         ]
#         log.info('waiting for executor tasks')
#         completed, pending = await asyncio.wait(blocking_tasks)
#         results = completed
#         log.info('results: {!r}'.format(results))
#         log.info('exiting')
#
#     def run(self, data):
#         # Configure logging to show the name of the thread
#         # where the log message originates.
#         logging.basicConfig(
#             level=logging.INFO,
#             format='%(threadName)10s %(name)18s: %(message)s',
#             stream=sys.stderr,
#         )
#         ceph_resource = CephAdapterInstance()
#         ceph_resource.set_resource()
#         # Create a limited thread pool.
#         executor = concurrent.futures.ThreadPoolExecutor(
#             max_workers=8,
#         )
#
#         try:
#             self.loop.run_until_complete(
#                 self.run_blocking_tasks(executor, data, ceph_resource)
#             )
#         finally:
#             self.loop.close()
#
#     async def gather_tasks(self, list_reports):
#         ceph_resource = CephAdapterInstance()
#         ceph_resource.set_resource()
#         reports_tasks = [self.save_report_ceph(report, ceph_resource) for report in list_reports]
#         self.loop.run_until_complete(asyncio.wait(reports_tasks))
#
#     def save_report_ceph(self, report, ceph_resource):
#         log = logging.getLogger('run_blocking_tasks')
#         log.info(report.data['file'])
#         reconciliation_report_manager = ReconciliationReportArtifactManager(report.data)
#         reconciliation_report_artifact = reconciliation_report_manager.save_pdf_file()
#         data = ceph_resource.save_object_resource(file=reconciliation_report_artifact,
#                                                   object_name=report.data['file'])
#         ao_logger.log('Info', f'provider: {str(data)}')

class ReconciliationReportCephSave:
    def __init__(self):
        self.loop = asyncio.new_event_loop()

    def run(self, data):
        asyncio.run(self.gather_tasks(data))
        asyncio.set_event_loop(self.loop)
        future = asyncio.ensure_future(self.gather_tasks(data))
        self.loop.run_until_complete(future)

    async def gather_tasks(self, list_reports):
        # ceph_resource = CephAdapterInstance()
        # ceph_resource.set_resource()
        reports_tasks = [self.save_report_ceph(report) for report in list_reports]
        await asyncio.gather(*reports_tasks)

    async def save_report_ceph(self, report):
        reconciliation_report_manager = ReconciliationReportArtifactManager(report.data)
        reconciliation_report_artifact = reconciliation_report_manager.save_pdf_file()
        CephAdapter.save_object(file=reconciliation_report_artifact, bucket_name=CEPH_BUCKET_NAME,
                                object_name=report.data['file'])
        # ao_logger.log('Info', f'provider: {str(data)}')
