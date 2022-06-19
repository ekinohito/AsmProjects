import unittest
from cpp_parser import *


class TestParser(unittest.TestCase):
    def assertParsed(self, parsed: Parsed, expected_leftover: str = ''):
        leftover, ok = parsed
        self.assertTrue(ok, msg=f'Parsing is not ok: {parsed}')
        self.assertEqual(leftover, expected_leftover, msg=f'Unexpected leftover')
    
    def assertNotParsed(self, parsed: Parsed):
        _, ok = parsed
        self.assertFalse(ok, msg=f'Parsing succeded: {parsed}')
    
    def test_is_var(self):
        self.assertParsed(is_var('a'))
        self.assertParsed(is_var('bcd'))
        self.assertParsed(is_var('PascalCase'))
        self.assertNotParsed(is_var('1startswithdigit'))
        self.assertParsed(is_var('endsswithdigit2'))
    
    def test_is_integer(self):
        self.assertParsed(is_integer('123'))
        self.assertParsed(is_integer('-234'))
        self.assertNotParsed(is_integer('-'))
        self.assertParsed(is_integer('1.23'), '.23')
    
    def test_is_while(self):
        self.assertParsed(is_while('while(x)t=2'))
        self.assertParsed(is_while('while(x)while(y)j=-10'))
        self.assertNotParsed(is_while('while(x)'))
        self.assertNotParsed(is_while('while(-x)x=x'))

    def test_is_assignment(self):
        self.assertParsed(is_assignment('x=1'))
        self.assertParsed(is_assignment('y=z'))
        self.assertNotParsed(is_assignment('y='))
        self.assertNotParsed(is_assignment('=9'))
        


if __name__ == '__main__':
    unittest.main()