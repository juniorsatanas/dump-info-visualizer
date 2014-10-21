timing_test(function() {
  at(0.25 * 1000, function() {
    assert_styles('#a', {'left':'200px'});
  }, "Autogenerated test for #a at t=3.25");
  at(0.5 * 1000, function() {
    assert_styles('#a', {'left':'300px'});
  }, "Autogenerated test for #a at t=3.5");
  at(0.75 * 1000, function() {
    assert_styles('#a', {'left':'400px'});
  }, "Autogenerated test for #a at t=3.75");
  at(1 * 1000, function() {
    assert_styles('#a', {'left':'100px'});
  }, "Autogenerated test for #a at t=4");
  at(1.25 * 1000, function() {
    assert_styles('#a', {'left':'400px'});
  }, "Autogenerated test for #a at t=4.25");
  at(1.5 * 1000, function() {
    assert_styles('#a', {'left':'300px'});
  }, "Autogenerated test for #a at t=4.5");
  at(1.75 * 1000, function() {
    assert_styles('#a', {'left':'200px'});
  }, "Autogenerated test for #a at t=4.75");
  at(2 * 1000, function() {
    assert_styles('#a', {'left':'100px'});
  }, "Autogenerated test for #a at t=5");
  at(2.25 * 1000, function() {
    assert_styles('#a', {'left':'200px'});
  }, "Autogenerated test for #a at t=5.25");
  at(2.5 * 1000, function() {
    assert_styles('#a', {'left':'300px'});
  }, "Autogenerated test for #a at t=5.5");
  at(2.75 * 1000, function() {
    assert_styles('#a', {'left':'400px'});
  }, "Autogenerated test for #a at t=5.75");
  at(3.0 * 1000, function() {
    assert_styles('#a', {'left':'100px'});
  }, "Autogenerated test for #a at t=6.0");
  at(4.0 * 1000, function() {
    assert_styles('#a', {'left':'100px'});
  }, "Autogenerated test for #a at t=7.0");
}, "Autogenerated checks.");