import React from 'react';
import { Route } from 'react-router-dom';
import styled from 'styled-components';

import Calendar from './Calendar';
import TodaysInfo from './TodaysInfo';
import DailyList from './DailyList';
import EntryComment from './EntryComment';

const Wrapper = styled.div`
  .bgcolor_danger_light { background-color: #e4816a !important; }
  .bgcolor_warning_light { background-color: #f0c03b !important; }
  .bgcolor_success { background-color: #a5c74c !important; }
  .bgcolor_success_light { background-color: #72bbca !important; }
  .bgcolor_aux_1 { background-color: #a69687 !important; }
  .bgcolor_aux_2_light { background-color: #bd9cca !important; }
  .bgcolor_info_light { background-color: #76a7db !important; }
  .bgcolor_info { background-color: #007BD4 !important; }

  .btn,
  a.btn {
    display: inline-block;
    padding: 6px .75em 4px;
    margin-right:5px;
    border-radius: 5px;
    line-height: 12px;
    text-align: center;
    color: #fff;
  }

  .listbtn {
    display: inline-block;
    padding: 3px;
    margin-right:5px;
    border-radius: 5px;
    line-height: 15px;
    text-align: center;
    color: #fff;
  }

  img {
    max-width: 100%;
    height: auto;
  }

  .btn_op {
    display: inline-block;
    padding: 0;
    border-radius: 5px;
    text-align: center;
    display: block;
    width: 25px;
    height: 25px;
    line-height: 0;
    background: #666;
    overflow: hidden;

    /* 横並びのための指定 */
    float: left;
    margin-right: 6px;
    /* ここまで */
  }
  .btn_reserveicon {
    background: #E4816A;
  }
  .btn_receipticon {
    background: #F0C03B;
  }
  .btn_monshinicon {
    background: #72BBCA;
  }
  .btn_interviewicon {
    background: #76A7DB;
  }
  .btn_inquiryicon {
    background: #BD9CCA;
  }
  
  div.editbutton {
    float: left;
    width: 28px;
    height: 28px;
  }
  div.editbuttoncancel {
    float: left;
    color: red;
  }
  div.editbutton_container {
    min-width: 200px;
    margin-top: 3px;
  }
  a {
    cursor: pointer;
  }
`;

const Frontdoor = (props) => (
  <Wrapper style={{ position: 'relative' }}>
    <div style={{ position: 'absolute', margin: '0px', backgroundColor: 'rgb(238, 238, 238)', height: '760px', width: '130px' }}>
      <Calendar {...props} />
    </div>

    <div style={{ marginLeft: '140px', minWidth: '600px' }}>
      <Route path="/reserve/frontdoor/todaysinfo" component={TodaysInfo} />
      <Route path="/reserve/frontdoor/dailylist" component={DailyList} />
      <Route path="/reserve/frontdoor/entrycomment" component={EntryComment} />
    </div>
  </Wrapper>
);

export default Frontdoor;
