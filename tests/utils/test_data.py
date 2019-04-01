# -*- coding: utf-8 -*-

import os
import pandas as pd
import pandas.api.types as pd_types
from pandas.util.testing import assert_frame_equal
from tempfile import NamedTemporaryFile
from unittest import TestCase

from oasislmf.utils.data import get_dataframe, set_dataframe_column_dtypes
from oasislmf.utils.exceptions import OasisException


class GetDataFrame(TestCase):

    def test_basic_read_csv(self):
        f = NamedTemporaryFile('w', delete=False)
        try:
            f.writelines([
                'a,b\n1,2\n3,4',
            ])
            f.close()
            df = get_dataframe(f.name, index=False)
            
            ref_data = {
                'a': [1, 3],
                'b': [2, 4]
            }

            ref_df = pd.DataFrame.from_dict(ref_data)
        finally:
            os.remove(f.name)

        assert_frame_equal(df, ref_df)

    def test_all_required_cols_present_in_csv(self):
        f = NamedTemporaryFile('w', delete=False)
        try:
            f.writelines([
                'A,b\n1,2\n3,4',
            ])
            f.close()
            df = get_dataframe(
                f.name, lowercase_cols=False, index=False, required_cols=['A', 'b'])
            
            ref_data = {
                'A': [1, 3],
                'b': [2, 4]
            }

            ref_df = pd.DataFrame.from_dict(ref_data)
        finally:
            os.remove(f.name)

        assert_frame_equal(df, ref_df)

    def test_all_required_cols_present_in_csv_case_insensitive(self):
        f = NamedTemporaryFile('w', delete=False)
        try:
            f.writelines([
                'a,b\n1,2\n3,4',
            ])
            f.close()
            df = get_dataframe(
                f.name, index=False, lowercase_cols=True, required_cols=['A', 'B'])
            
            ref_data = {
                'a': [1, 3],
                'b': [2, 4]
            }

            ref_df = pd.DataFrame.from_dict(ref_data)
        finally:
            os.remove(f.name)

        assert_frame_equal(df, ref_df)

    def test_missing_required_cols_in_csv_throws_exception(self):
        f = NamedTemporaryFile('w', delete=False)
        try:
            with self.assertRaises(OasisException):
                f.writelines([
                    'a,b\n1,2\n3,4',
                ])
                f.close()
                get_dataframe(f.name, index=False, required_cols=['a', 'b', 'c'])
        finally:
            os.remove(f.name)

    def test_all_default_cols_present_in_csv(self):
        f = NamedTemporaryFile('w', delete=False)
        try:
            f.writelines([
                'a,b\n1,2\n3,4',
            ])
            f.close()
            df = get_dataframe(
                f.name, index=False, col_defaults={'a': 1, 'b': 2})

            ref_data = {
                'a': [1, 3],
                'b': [2, 4],
            }

            ref_df = pd.DataFrame.from_dict(ref_data)
        finally:
            os.remove(f.name)

        assert_frame_equal(df, ref_df)

    def test_all_add_default_str_in_csv(self):
        f = NamedTemporaryFile('w', delete=False)
        try:
            f.writelines([
                'a,b\n1,2\n3,4',
            ])
            f.close()
            df = get_dataframe(f.name, index=False, col_defaults={'c': 'abc'})

            ref_data = {
                'a': [1, 3],
                'b': [2, 4],
                'c': ['abc', 'abc']
            }

            ref_df = pd.DataFrame.from_dict(ref_data)
        finally:
            os.remove(f.name)

        assert_frame_equal(df, ref_df)

    def test_all_add_default_number_in_csv(self):
        f = NamedTemporaryFile('w', delete=False)
        try:
            f.writelines([
                'a,b\n1,2\n3,4',
            ])
            f.close()
            df = get_dataframe(f.name, index=False, col_defaults={'c': 9.99})

            ref_data = {
                'a': [1, 3],
                'b': [2, 4],
                'c': [9.99, 9.99]
            }

            ref_df = pd.DataFrame.from_dict(ref_data)
        finally:
            os.remove(f.name)

        assert_frame_equal(df, ref_df)

    def test_set_dataframe_column_dtypes(self):
        data = {
                'a': [1, 3]
        }
        df = pd.DataFrame.from_dict(data)
        assert pd_types.is_integer_dtype(df.a.dtype)
        
    def test_set_dataframe_column_dtypes_change_to_float(self):
        data = {
                'a': [1, 3]
        }
        df = pd.DataFrame.from_dict(data)
        set_dataframe_column_dtypes(df, {"a": "float"})
        assert pd_types.is_float_dtype(df.a.dtype)

    def test_set_dataframe_column_dtypes_change_to_string(self):
        data = {
                'a': [1, 3]
        }
        df = pd.DataFrame.from_dict(data)
        set_dataframe_column_dtypes(df, {"a": "str"})
        assert pd_types.is_string_dtype(df.a.dtype)

    def test_set_dataframe_column_dtypes_ignore_extra_columns(self):
        data = {
                'a': [1, 3]
        }
        df = pd.DataFrame.from_dict(data)
        set_dataframe_column_dtypes(df, {"a": "str", "b": "int"})
        assert pd_types.is_string_dtype(df.a.dtype)
