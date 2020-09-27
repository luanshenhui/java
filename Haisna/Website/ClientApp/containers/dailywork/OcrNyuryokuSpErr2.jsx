import React from 'react';
import styled from 'styled-components';
import { Field, reduxForm } from 'redux-form';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import Table from '../../components/Table';
import { FieldGroup, FieldSet } from '../../components/Field';
import DropDown from '../../components/control/dropdown/DropDown';

import { changeOcrNyuryokuSpErr2Info } from '../../modules/dailywork/questionnaire1Module';

const formName = 'OcrNyuryokuSpErr2';

// 出力区分選択肢
const outItems = [{ value: '0', name: '全て' }, { value: '1', name: 'エラー' }, { value: '2', name: '警告' }];

const WrapperSpace = styled.span`
  padding: 0 2px;
  background-color : #FFFFFF;
`;

class OcrNyuryokuSpErr2 extends React.Component {
  constructor(props) {
    super(props);
    this.handleonchageouterr = this.handleonchageouterr.bind(this);
  }

  // 値を変更時の処理
  handleonchageouterr(event) {
    if (event === null || event === undefined) {
      return;
    }
    const { onChange } = this.props;
    const target = event.target;
    const value = target.value;
    onChange(value);
  }

  // エーらを選択
  handleJumpAnchor = (errid) => {
    if (errid) {
      const anchorElement = document.getElementById(`Anchor-ErrInfo${errid}`);
      let PosY = anchorElement.offsetTop;
      PosY -= 528;
      document.getElementById('OcrNyuryokuSpBody2').scrollTo(0, Number(PosY));
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
      for (let i = 0; i < errInfo.errCount; i += 1) {
        const errno = errInfo.errNo[i];
        const errstate = errInfo.errState[i];
        const errmessage = errInfo.errMessage[i];
        if (errstate === '1') {
          errtypetrxt = 'エラー';
        } else if (errstate === '2') {
          errtypetrxt = '警告';
        } else {
          break;
        }
        if (gettype !== '0') {
          if (gettype === errstate) {
            edithtml.push(<td key={`${i}-${i}-0`} style={{ height: '12px', background: '#ffffff', width: '100px' }}>{errtypetrxt}</td>);
            edithtml.push(
              <td key={`${i}-1`} style={{ height: '12px', background: '#ffffff', width: '1165px' }}>
                <a style={{ cursor: 'pointer', textDecoration: 'underline' }} role="presentation" onClick={() => (this.handleJumpAnchor(errno))}>
                  <span style={{ color: '#006699', fontSize: '16px' }}>{errmessage}</span>
                </a>
              </td>);
          }
        } else {
          edithtml.push(<td key={`${i}-${i}-0`} style={{ height: '12px', background: '#ffffff', width: '100px' }}>{errtypetrxt}</td>);
          edithtml.push(
            <td key={`${i}-1`} style={{ height: '12px', background: '#ffffff', width: '1165px' }}>
              <a style={{ cursor: 'pointer', textDecoration: 'underline' }} role="presentation" onClick={() => (this.handleJumpAnchor(errno))}>
                <span style={{ color: '#006699', fontSize: '16px' }}>{errmessage}</span>
              </a>
            </td>);
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
            <Table style={{ width: 1645 }}>
              <thead>
                <tr>
                  <td style={{ height: '12px', width: '45px' }}>表示:</td>
                  <td><Field name="outItems" component={DropDown} items={outItems} id="outItems" onChange={this.handleonchageouter} /></td>
                  <td style={{ height: '12px', background: '#f0f0f0', width: '100px' }}>状態</td>
                  <td><WrapperSpace /></td>
                  <td style={{ height: '12px', background: '#f0f0f0', width: '1475px' }}>メッセージ</td>
                </tr>
              </thead>
            </Table>
          </FieldSet>
          <FieldSet>
            <div style={{ width: 1645, paddingLeft: 110, marginTop: -10 }}>
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
OcrNyuryokuSpErr2.propTypes = {
  errInfo: PropTypes.shape(),
  changeflag: PropTypes.number.isRequired,
  onChange: PropTypes.func.isRequired,
};

OcrNyuryokuSpErr2.defaultProps = {
  errInfo: {},
};

const OcrNyuryokuErr2Form = reduxForm({
  form: formName,
  enableReinitialize: true,
})(OcrNyuryokuSpErr2);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  errInfo: state.app.dailywork.questionnaire2.ocrNyuryokuSpBody2.errInfo,
  changeflag: state.app.dailywork.questionnaire1.ocrNyuryokuSpErr2.changeflag,
});

const mapDispatchToProps = (dispatch) => ({
  // 画面値変更後の処理
  onChange: (params) => {
    dispatch(changeOcrNyuryokuSpErr2Info(params));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(OcrNyuryokuErr2Form);
