import React from 'react';
import styled from 'styled-components';
import { Field, formValueSelector } from 'redux-form';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import Table from '../../components/Table';
import { FieldGroup, FieldSet } from '../../components/Field';
import DropDown from '../../components/control/dropdown/DropDown';

import { changeOcrNyuryokuSpErr201210Info } from '../../modules/dailywork/questionnaire1Module';

const formName = 'OcrNyuryoku';

// 出力区分選択肢
const outItems = [{ value: 0, name: '全て' }, { value: 1, name: 'エラー' }, { value: 2, name: '警告' }];

const WrapperSpace = styled.span`
  padding: 0 2px;
  background-color : #FFFFFF;
`;

class OcrNyuryokuSpErr201210 extends React.Component {
  constructor(props) {
    super(props);
    this.handleonchageouterr = this.handleonchageouterr.bind(this);
  }

  // 確定ボタン押下時の処理
  handleonchageouterr(event) {
    if (event === null || event === undefined) {
      return;
    }
    const { onChange } = this.props;
    const { target } = event;
    const { value } = target;
    onChange(value);
  }

  // エーらを選択
  handleJumpAnchor = (errid) => {
    if (errid) {
      const anchorElement = document.getElementById(`Anchor-ErrInfo${errid}`);
      let PosY = anchorElement.offsetTop;
      PosY -= 528;
      document.getElementById('OcrNyuryokuSpBody201210').scrollTo(0, Number(PosY));
    }
  }

  editListBody = (parms) => {
    const reslife = [];
    let edithtml = [];
    let gettype = 0;
    let errtypetrxt;
    const { errInfo, changeflag } = parms;
    gettype = changeflag;

    // 各表示列ごとの編集
    if (changeflag !== null && errInfo !== null) {
      const { errState, errMessage, errNo, errCount } = errInfo;
      for (let i = 0; i < errCount; i += 1) {
        if (errState[i] === '1') {
          errtypetrxt = 'エラー';
        } else if (errState[i] === '2') {
          errtypetrxt = '警告';
        } else {
          break;
        }
        if (gettype !== 0) {
          if (gettype === errState) {
            edithtml.push(<td key={`${i}-${i}-0`} style={{ height: '12px', background: '#ffffff', width: '100px' }}>{errtypetrxt}</td>);
            edithtml.push((
              <td key={`${i}-1`} style={{ height: '12px', background: '#ffffff', width: '880px' }}>
                <a style={{ cursor: 'pointer', textDecoration: 'underline' }} role="presentation" onClick={() => (this.handleJumpAnchor(errNo[i]))}>
                  <span style={{ color: '#006699', fontSize: '16px' }}>{errMessage[i]}</span>
                </a>
              </td>));
          }
        } else {
          edithtml.push(<td key={`${i}-${i}-0`} style={{ height: '12px', background: '#ffffff', width: '100px' }}>{errtypetrxt}</td>);
          edithtml.push((
            <td key={`${i}-1`} style={{ height: '12px', background: '#ffffff', width: '880px' }}>
              <a style={{ cursor: 'pointer', textDecoration: 'underline' }} role="presentation" onClick={() => (this.handleJumpAnchor(errNo[i]))}>
                <span style={{ color: '#006699', fontSize: '16px' }}>{errMessage[i]}</span>
              </a>
            </td>));
        }
        reslife.push(<tr style={{ background: '#ffffff', height: '12px' }} key={`${i}`}>{edithtml}</tr>);
        edithtml = [];
      }
    }
    return reslife;
  }

  render() {
    const { errInfo, changeflag } = this.props;
    return (
      <form>
        <FieldGroup>
          <FieldSet>
            <Table style={{ width: 1095 }}>
              <thead>
                <tr>
                  <td style={{ height: '12px', width: '45px' }}>表示:</td>
                  <td><Field name="outItems" component={DropDown} items={outItems} id="outItems" onChange={this.handleonchageouter} /></td>
                  <td style={{ height: '12px', background: '#f0f0f0', width: '100px' }}>状態</td>
                  <td><WrapperSpace /></td>
                  <td style={{ height: '12px', background: '#f0f0f0', width: '880px' }}>メッセージ</td>
                </tr>
              </thead>
            </Table>
          </FieldSet>
          <FieldSet>
            <div style={{ width: 1095, paddingLeft: 110, marginTop: -10 }}>
              <Table>
                <tbody>
                  {this.editListBody({ errInfo, changeflag })}
                </tbody>
              </Table>
            </div>
          </FieldSet>
        </FieldGroup>
      </form>
    );
  }
}

// propTypesの定義
OcrNyuryokuSpErr201210.propTypes = {
  errInfo: PropTypes.shape(),
  changeflag: PropTypes.number.isRequired,
  onChange: PropTypes.func.isRequired,
};

OcrNyuryokuSpErr201210.defaultProps = {
  errInfo: {},
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const selector = formValueSelector(formName);
  return {
    changeflag: state.app.dailywork.questionnaire1.ocrNyuryokuSpErr201210.changeflag,
    errInfo: selector(state, 'errInfo'),
  };
};

const mapDispatchToProps = (dispatch) => ({
  // 画面値変更後の処理
  onChange: (params) => {
    dispatch(changeOcrNyuryokuSpErr201210Info(params));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(OcrNyuryokuSpErr201210);
