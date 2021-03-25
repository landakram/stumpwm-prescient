(defpackage stumpwm-prescient/tests/main
  (:use :cl
        :stumpwm-prescient
        :rove))
(in-package :stumpwm-prescient/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :stumpwm-prescient)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
