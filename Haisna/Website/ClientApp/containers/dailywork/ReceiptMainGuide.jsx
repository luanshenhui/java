import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import { reduxForm } from 'redux-form';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../components/Field';
import MessageBanner from '../../components/MessageBanner';
import GuideButton from '../../components/GuideButton';
import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import PubnoteListBody from './PubnoteListBody';
import FriendsListBody from './FriendsListBody';
import PerrslListBody from './PerrslListBody';

import { registerWelComeInfoRequest, closeReceiptMainGuide, loadPeceiptMainInfo, openEditWelComeInfoGuide } from '../../modules/reserve/consultModule';

const formName = 'ReceiptMainGuide';

class ReceiptMainGuide extends React.Component {
  componentDidMount() {
    const { onLoad, rsvno } = this.props;
    const params = { rsvno };
    // onLoadアクションの引数として渡す
    onLoad(params);
  }

  // urlボタンクリック時の処理
  handleUrlClick(mode) {
    const { rsvno } = this.props;
    const { onOpen } = this.props;
    const data = { rsvno, mode };
    onOpen(data);
  }

  editListBody = (getoptdata) => {
    let countsum = 0;
    let getnum = 0;

    // オプション情報の表示行数
    if (getoptdata) {
      countsum = (getoptdata.length) / 3;
      getnum = getoptdata.length % 3;
      if (getnum > 0) {
        if (countsum >= 1) {
          countsum += 1;
        }
      }
      if (countsum > 0 && countsum < 1) {
        countsum = 1;
      }
    }
    // 各表示列ごとの編集
    const reslife = [];
    for (let i = 0; i < countsum; i += 1) {
      const edithtml = [];
      for (let j = 0; j < 3; j += 1) {
        const recdate = getoptdata[i * 3 + j];
        if (j > 0) {
          edithtml.push(<Label key={`${i.toString()}-${j.toString()}-0`} />);
        }
        if ((i * 3 + j) < getoptdata.length) {
          edithtml.push(<Label key={`${i.toString()}-${j.toString()}-1`}><span style={{ color: `#${recdate.setcolor}` }}>■</span>{recdate.optsname}</Label>);
        } else {
          edithtml.push(<Label key={`${i.toString()}-${j.toString()}-2`} />);
        }
      }
      edithtml.push(<br key={`${i.toString()}-0`} />);
      reslife.push(<Label key={`${i.toString()}`}>{edithtml}</Label>);
    }
    return reslife;
  }
  render() {
    const { message, dayidtxt, realagetxt, getwelcomedata, gethisdata, getoptdata } = this.props;

    return (
      <div>
        <MessageBanner messages={message} />
        <form>
          <FieldGroup>
            <FieldSet>
              <GuideButton onClick={() => (this.handleUrlClick(1))} />
              <Label>当日ＩＤ</Label>
              <Label name="dayid"><nobr><span style={{ color: '#ff6600', fontSize: '45px' }}>{dayidtxt}</span></nobr></Label>
            </FieldSet>
            <FieldSet>
              <FieldItem><nobr>受診日</nobr></FieldItem>
              <Label style={{ width: 70 }} >{getwelcomedata ?
                <span style={{ color: '#ff6600' }}><b>{moment(getwelcomedata.csldate).format('YYYY/MM/DD')}</b></span> : <Label style={{ width: 70 }} />}
              </Label>
              <FieldItem><nobr>予約番号</nobr></FieldItem>
              <Label style={{ width: 70 }} >{getwelcomedata ?
                <nobr><span style={{ color: '#ff6600' }}><b>{getwelcomedata.rsvno}</b></span></nobr> : <Label style={{ width: 70 }} />}
              </Label>
              <FieldItem><nobr>予約群</nobr></FieldItem>
              <Label style={{ width: 70 }} >{getwelcomedata ?
                <nobr><span style={{ color: '#ff6600' }}><b>{getwelcomedata.rsvgrpname}</b></span></nobr> : <Label style={{ width: 70 }} />}
              </Label>
              <FieldItem><nobr>来院情報</nobr></FieldItem>
              <Label style={{ width: 70 }} >{getwelcomedata ?
                <nobr><span style={{ color: '#ff6600' }}><b>{(!getwelcomedata.comedate) ? '未来院' : '来院済み'}</b></span></nobr> : <Label style={{ width: 70 }} />}
              </Label>
            </FieldSet>
            <FieldGroup itemWidth={200}>
              <FieldSet>
                {getwelcomedata ? getwelcomedata.perid : ''}
                <FieldValueList>
                  <FieldValue>
                    {getwelcomedata ?
                      <Label>
                        <span style={{ fontSize: '16px', fontWeight: 'bold' }} >
                          <Link to={`/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=${getwelcomedata.perid}`}>
                            &nbsp;{getwelcomedata.lastname}&nbsp;{getwelcomedata.firstname}
                          </Link>&nbsp;
                        </span>
                        <span style={{ color: '#999999' }}>({getwelcomedata.lastkname}&nbsp;{getwelcomedata.firstkname})&nbsp;{getwelcomedata.romename}</span>
                      </Label>
                      :
                      <Label><span style={{ fontSize: '16px', fontWeight: 'bold' }} >&nbsp;&nbsp;&nbsp;</span></Label>
                    }
                  </FieldValue>
                  <FieldValue>
                    {getwelcomedata ?
                      <Label>診察券：
                        <span style={{ color: '#007500' }} >
                          {(getwelcomedata && getwelcomedata.issuecslticket === 1) &&
                            <b>新規</b>
                          }
                          {(getwelcomedata && getwelcomedata.issuecslticket === 2) &&
                            <b>既存</b>
                          }
                          {(getwelcomedata && getwelcomedata.issuecslticket === 3) &&
                            <b>再発行</b>
                          }
                        </span>
                        {getwelcomedata.birthyearshorteraname && getwelcomedata.birthyearshorteraname}
                        {getwelcomedata.birtherayear}&nbsp;{(`${moment(getwelcomedata.birth).format('MM.DD')}生`)}
                        &nbsp;&nbsp;{`${realagetxt}歳`}&nbsp;{getwelcomedata.age ? `(${Math.floor(getwelcomedata.age.toString())}歳)` : ''}
                        &nbsp; {getwelcomedata.gendername && getwelcomedata.gendername}&nbsp;{getwelcomedata.gender === 1 ? '男性' : '女性'}
                      </Label>
                      :
                      <Label>(  )   生  歳</Label>
                    }
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
            </FieldGroup>
            <FieldSet>
              <FieldItem><nobr>受診コース</nobr></FieldItem>
              <Label style={{ width: 70 }} >{getwelcomedata ?
                <span style={{ color: '#ff6600' }}><b>{getwelcomedata.csname}</b></span> : <Label style={{ width: 70 }} />}
              </Label>
              <FieldItem><nobr>オプション</nobr></FieldItem>
              <div>
                {this.editListBody(getoptdata)}
              </div>
            </FieldSet>
            <FieldSet>
              <FieldItem>団体名</FieldItem>
              <div>
                <Label style={{ width: 70 }} >{getwelcomedata ?
                  <Label>{getwelcomedata.orgname} <span style={{ color: '#999999' }}><b>{`(${getwelcomedata.orgkname})`}</b></span></Label> : <Label style={{ width: 70 }} />}
                </Label>
              </div>
            </FieldSet>
            <br />
            <FieldGroup itemWidth={120}>
              <FieldSet>
                <FieldItem>利用券有無</FieldItem>
                {getwelcomedata ?
                  <div style={{ width: '60px' }}><Label>{(getwelcomedata.ticket === 1) ? 'あり' : 'なし'}</Label></div> : <div style={{ width: '60px' }}><Label /></div>}
                <FieldItem>保険証有無</FieldItem>
                {getwelcomedata ?
                  <div style={{ width: '60px' }}><Label>{(getwelcomedata.insbring === 1) ? 'あり' : 'なし'}</Label></div> : <div style={{ width: '60px' }}><Label /></div>}
                <FieldItem>本人/家族</FieldItem>
                {(getwelcomedata && getwelcomedata.billprint === 1) &&
                  <div style={{ width: '60px' }}><Label>本人</Label></div>
                }
                {(getwelcomedata && getwelcomedata.billprint === 2) &&
                  <div style={{ width: '60px' }}><Label>家族</Label></div>
                }
                {(getwelcomedata === undefined) &&
                  <div style={{ width: '60px' }}><Label /></div>
                }
              </FieldSet>
              <FieldSet>
                <FieldItem>回収済み</FieldItem>
                {getwelcomedata ?
                  <div style={{ width: '60px' }}><Label>{(getwelcomedata.collectticket === null) ? '未回収' : '済み'}</Label></div> : <div style={{ width: '60px' }}><Label /></div>}
                <FieldItem>保険証記号</FieldItem>
                <div style={{ width: '60px' }}><Label>{getwelcomedata !== undefined ? getwelcomedata.isrsign : <div style={{ width: '60px' }}><Label /></div>}</Label></div>
                <FieldItem>成績表宛先</FieldItem>
                {(getwelcomedata && getwelcomedata.reportaddrdiv === 1) &&
                  <div style={{ width: '150px' }}><Label>住所（自宅）</Label></div>
                }
                {(getwelcomedata && getwelcomedata.reportaddrdiv === 2) &&
                  <div style={{ width: '150px' }}><Label>住所（会社）</Label></div>
                }
                {(getwelcomedata && getwelcomedata.reportaddrdiv === 3) &&
                  <div style={{ width: '150px' }}><Label>住所（その他）</Label></div>
                }
                {(getwelcomedata === undefined) &&
                  <div style={{ width: '150px' }}><Label /></div>
                }
              </FieldSet>
              <FieldSet>
                <FieldItem>保険証番号</FieldItem>
                <div style={{ width: '100px' }}><Label>{getwelcomedata ? getwelcomedata.isrno : <div style={{ width: '100px' }}><Label /></div>}</Label></div>
                <FieldItem>成績表英文出力</FieldItem>
                {getwelcomedata ?
                  <div style={{ width: '92px' }}><Label>{(getwelcomedata.reportoureng === 1) ? 'あり' : 'なし'}</Label></div> : <div style={{ width: '92px' }}><Label /></div>}
              </FieldSet>
              <FieldSet>
                <div style={{ width: '1200px', overflowY: 'auto', overflowX: 'auto', height: '180px' }}>
                  <PubnoteListBody />
                </div>
              </FieldSet>
              <FieldSet>
                <FieldItem>ボランティア</FieldItem>
                {(getwelcomedata && getwelcomedata.volunteer === 0) &&
                  <div style={{ width: '150px' }}><Label>利用なし</Label></div>
                }
                {(getwelcomedata && getwelcomedata.volunteer === 1) &&
                  <div style={{ width: '150px' }}><Label>通訳要</Label></div>
                }
                {(getwelcomedata && getwelcomedata.volunteer === 2) &&
                  <div style={{ width: '150px' }}><Label>介護要</Label></div>
                }
                {(getwelcomedata && getwelcomedata.volunteer === 3) &&
                  <div style={{ width: '150px' }}><Label>通訳＆介護要</Label></div>
                }
                {(getwelcomedata && getwelcomedata.volunteer === 4) &&
                  <div style={{ width: '150px' }}><Label>車椅子要</Label></div>
                }
                {(getwelcomedata.volunteer === undefined || getwelcomedata.volunteer === null) &&
                  <div style={{ width: '60px' }}><Label /></div>
                }
                <FieldItem>来院処理担当</FieldItem>
                <div style={{ width: '80px' }}><Label>{getwelcomedata ? getwelcomedata.comeuser : <div style={{ width: '60px' }}><Label /></div>}</Label></div>
                <FieldItem>ＯＣＲ番号</FieldItem>
                <div style={{ width: '60px' }}><Label>{getwelcomedata ? getwelcomedata.ocrno : <div style={{ width: '60px' }}><Label /></div>}</Label></div>
              </FieldSet>
              <FieldSet>
                <FieldItem>ボランティア名</FieldItem>
                <div style={{ width: '60px' }}><Label>{getwelcomedata ? getwelcomedata.volunteername : <div style={{ width: '60px' }}><Label /></div>} </Label></div>
                <FieldItem>来院日時</FieldItem>
                <div style={{ width: '200px' }}>
                  <Label>{getwelcomedata && getwelcomedata.comedate ? moment(getwelcomedata.comedate).format('YYYY/MM/DD HH:mm:ss') : ''}
                  </Label>
                </div>
                <FieldItem>ロッカーキー</FieldItem>
                <div style={{ width: '60px' }}><Label>{getwelcomedata ? getwelcomedata.lockerkey : <div style={{ width: '60px' }}><Label /></div>}</Label></div>
              </FieldSet>
              <FieldSet>
                <FieldItem>国籍</FieldItem>
                <div style={{ width: '60px' }}><Label>{getwelcomedata ? getwelcomedata.nationname : <div style={{ width: '60px' }}><Label /></div>}</Label></div>
                <FieldItem>案内書番号</FieldItem>
                <div style={{ width: '60px' }}><Label>{getwelcomedata ? getwelcomedata.rsvno : <div style={{ width: '60px' }}><Label /></div>}</Label></div>
              </FieldSet>
              <FieldSet>
                <div style={{ width: '1200px', overflowY: 'auto', overflowX: 'auto', height: '70px' }}>
                  <FriendsListBody />
                </div>
              </FieldSet>
            </FieldGroup>
            <FieldGroup itemWidth={120}>
              <FieldSet>
                <FieldItem>前回受診日</FieldItem>
                {(gethisdata && gethisdata.consultHistoryData && gethisdata.consultHistoryData.length === 2) &&
                  <Label>{moment(gethisdata.consultHistoryData[1].csldate).format('YYYY/MM/DD')}&nbsp;{gethisdata.consultHistoryData[1].csname}</Label>
                }
                {(gethisdata && gethisdata.consultHistoryData && gethisdata.consultHistoryData.length !== 2) &&
                  <Label />
                }
              </FieldSet>
              <FieldSet>
                <FieldItem>身体情報</FieldItem>
                <PerrslListBody />
              </FieldSet>
              <FieldSet>
                <div style={{ width: 155 }}>
                  <Button type="submit" onClick={() => (this.handleUrlClick(4))} value="ロッカーキーを入力" />
                </div>
                <div style={{ width: 110, marginLeft: '2px' }}>
                  <Button type="submit" onClick={() => (this.handleUrlClick(2))} value="来院情報修正" />
                </div>
                <div style={{ width: 110, marginLeft: '2px' }}>
                  <Button type="submit" onClick={() => (this.handleUrlClick(3))} value="OCR番号修正" />
                </div>
                <div style={{ width: 110, marginLeft: '4px' }}>
                  <Button type="submit" onClick={() => (this.handleUrlClick(99))} value="希望医師入力" />
                </div>
              </FieldSet>
            </FieldGroup>
          </FieldGroup>
        </form>
      </div>
    );
  }
}

// propTypesの定義
ReceiptMainGuide.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  rsvno: PropTypes.string.isRequired,
  dayidtxt: PropTypes.string.isRequired,
  onOpen: PropTypes.func.isRequired,
  realagetxt: PropTypes.number.isRequired,
  getwelcomedata: PropTypes.shape(),
  gethisdata: PropTypes.shape(),
  getoptdata: PropTypes.arrayOf(PropTypes.shape()),
};

ReceiptMainGuide.defaultProps = {
  getwelcomedata: {},
  gethisdata: {},
  getoptdata: [],
};

const ReceiptMainForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(ReceiptMainGuide);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  visible: state.app.reserve.consult.receiptMainGuide.visible,
  message: state.app.reserve.consult.receiptMainGuide.message,
  data: state.app.reserve.consult.receiptMainGuide.data,
  rsvno: state.app.reserve.consult.receiptMainGuide.rsvno,
  receiptflg: state.app.reserve.consult.receiptMainGuide.receiptflg,
  dayidtxt: state.app.reserve.consult.receiptMainGuide.dayidtxt,
  realagetxt: state.app.reserve.consult.receiptMainGuide.realagetxt,
  getwelcomedata: state.app.reserve.consult.receiptMainGuide.data.getwelcomedata,
  gethisdata: state.app.reserve.consult.receiptMainGuide.data.gethisdata,
  getoptdata: state.app.reserve.consult.receiptMainGuide.data.getoptdata,
});

const mapDispatchToProps = (dispatch) => ({
  // 来院確認処理
  onSerchSubmit: (data) => {
    // 処理を呼び出す
    dispatch(registerWelComeInfoRequest({ data }));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeReceiptMainGuide());
  },
  // 画面を初期化
  onLoad: (params) => {
    dispatch(loadPeceiptMainInfo(params));
  },
  // 閉じるアクションを呼び出す
  onOpen: (params) => {
    dispatch(openEditWelComeInfoGuide(params));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(ReceiptMainForm);
